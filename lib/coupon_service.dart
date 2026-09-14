import 'api_client.dart';
import 'api_models.dart';

/// Wraps nexalink-api's `/api/v1/coupons` (see coupon.api.CouponController). Only
/// the cart-preview `validate` call lives here — the actual apply-and-charge step
/// happens server-side inside `OrderService.checkout` (order_service.dart passes
/// the coupon code through on `/orders/checkout`), never client-side.
class CouponService {
  final ApiClient _client = ApiClient.instance;

  Future<CouponValidation> validate({required String code, required double orderTotal}) => _client.get(
        '/coupons/validate?code=${Uri.encodeQueryComponent(code)}&orderTotal=$orderTotal',
        (json) => CouponValidation.fromJson(json as Map<String, dynamic>),
      );
}
