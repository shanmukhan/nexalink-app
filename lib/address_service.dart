import 'api_client.dart';
import 'api_models.dart';

/// Wraps nexalink-api's `/api/v1/customers/me/addresses` (see
/// CustomerController).
class AddressService {
  final ApiClient _client = ApiClient.instance;

  Future<List<Address>> listAddresses() => _client.get(
        '/customers/me/addresses',
        (json) => (json as List<dynamic>).map((e) => Address.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Address> addAddress({
    required String type,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required String postalCode,
    bool isDefault = true,
  }) =>
      _client.post(
        '/customers/me/addresses',
        {
          'type': type,
          'line1': line1,
          'line2': line2,
          'city': city,
          'state': state,
          'postalCode': postalCode,
          'isDefault': isDefault,
        },
        (json) => Address.fromJson(json as Map<String, dynamic>),
      );
}
