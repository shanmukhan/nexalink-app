import 'api_client.dart';
import 'api_models.dart';

/// Wraps nexalink-api's `/api/v1/referrals/*` (see referral.api.ReferralController).
class ReferralService {
  final ApiClient _client = ApiClient.instance;

  Future<ReferralSummary> getMySummary() => _client.get('/referrals/me', (json) => ReferralSummary.fromJson(json as Map<String, dynamic>));
}
