import 'package:flutter/foundation.dart';

import 'api_client.dart';

/// Wraps nexalink-api's `/api/v1/auth/*` (see AuthController): OTP request +
/// verify, persisting the returned access/refresh tokens via [ApiClient].
class AuthService {
  final ApiClient _client = ApiClient.instance;

  String channelFor(String identifier) => _isPhoneNumber(identifier) ? 'PHONE' : 'EMAIL';

  bool _isPhoneNumber(String identifier) => RegExp(r'^[6-9]\d{9}$').hasMatch(identifier.trim());

  Future<void> requestOtp(String identifier) async {
    await _client.post<void>(
      '/auth/otp/request',
      {'channel': channelFor(identifier), 'identifier': identifier.trim()},
      (_) {},
      auth: false,
    );
  }

  Future<void> verifyOtp(String identifier, String otp, {String? referralCode}) async {
    final deviceId = await _client.deviceIdentifier();
    final tokens = await _client.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      {
        'channel': channelFor(identifier),
        'identifier': identifier.trim(),
        'otp': otp.trim(),
        'deviceIdentifier': deviceId,
        'platform': _platform(),
        if (referralCode != null && referralCode.trim().isNotEmpty) 'referralCode': referralCode.trim(),
      },
      (json) => json as Map<String, dynamic>,
      auth: false,
    );
    await _client.saveSession(
      accessToken: tokens['accessToken'] as String,
      refreshToken: tokens['refreshToken'] as String,
    );
  }

  Future<void> logout() async {
    final refreshToken = _client.refreshToken;
    if (refreshToken != null) {
      try {
        await _client.post<void>('/auth/logout', {'refreshToken': refreshToken}, (_) {}, auth: false);
      } catch (_) {
        // best-effort: still clear the local session below
      }
    }
    await _client.clearSession();
  }

  String _platform() {
    if (kIsWeb) return 'WEB';
    return defaultTargetPlatform == TargetPlatform.iOS ? 'IOS' : 'ANDROID';
  }
}
