import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Base URL of `nexalink-api`. Android emulators reach the host machine via
/// 10.0.2.2, not localhost — see docs/00_Backend_Overview.md for other
/// environments (iOS simulator/web/desktop use localhost directly).
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8080/api/v1',
);

class ApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;

  ApiException(this.code, this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($code, $message)';
}

/// Thin wrapper over `nexalink-api`'s `/api/v1` endpoints: unwraps the
/// `{success, data, error}` envelope (see backend `common.web.ApiResponse`),
/// attaches the bearer token, and persists tokens/device id across launches.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  String? _accessToken;
  String? _refreshToken;
  String? _deviceIdentifier;

  String? get accessToken => _accessToken;
  bool get isLoggedIn => _accessToken != null;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    _deviceIdentifier = prefs.getString('device_identifier');
  }

  Future<String> deviceIdentifier() async {
    if (_deviceIdentifier != null) return _deviceIdentifier!;
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('device_identifier');
    if (id == null) {
      id = _randomId();
      await prefs.setString('device_identifier', id);
    }
    _deviceIdentifier = id;
    return id;
  }

  String _randomId() {
    final rand = Random.secure();
    return List.generate(32, (_) => rand.nextInt(16).toRadixString(16)).join();
  }

  Future<void> saveSession({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<void> clearSession() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  String? get refreshToken => _refreshToken;

  Map<String, String> _headers({bool auth = true}) {
    final headers = {'Content-Type': 'application/json'};
    if (auth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  Future<T> get<T>(String path, T Function(dynamic json) parse) async {
    final response = await http.get(Uri.parse('$kApiBaseUrl$path'), headers: _headers());
    return _unwrap(response, parse);
  }

  Future<T> post<T>(String path, Map<String, dynamic>? body, T Function(dynamic json) parse, {bool auth = true, Map<String, String>? extraHeaders}) async {
    final response = await http.post(
      Uri.parse('$kApiBaseUrl$path'),
      headers: {..._headers(auth: auth), ...?extraHeaders},
      body: body == null ? null : jsonEncode(body),
    );
    return _unwrap(response, parse);
  }

  Future<T> put<T>(String path, Map<String, dynamic> body, T Function(dynamic json) parse) async {
    final response = await http.put(
      Uri.parse('$kApiBaseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _unwrap(response, parse);
  }

  Future<T> delete<T>(String path, T Function(dynamic json) parse) async {
    final response = await http.delete(Uri.parse('$kApiBaseUrl$path'), headers: _headers());
    return _unwrap(response, parse);
  }

  T _unwrap<T>(http.Response response, T Function(dynamic json) parse) {
    Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('NETWORK_ERROR', 'Unexpected response from server', statusCode: response.statusCode);
    }
    final success = envelope['success'] == true;
    if (!success) {
      final error = envelope['error'] as Map<String, dynamic>?;
      throw ApiException(
        error?['code'] as String? ?? 'UNKNOWN_ERROR',
        error?['message'] as String? ?? 'Something went wrong',
        statusCode: response.statusCode,
      );
    }
    return parse(envelope['data']);
  }
}
