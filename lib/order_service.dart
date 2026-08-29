import 'api_client.dart';
import 'api_models.dart';

/// Wraps nexalink-api's `/api/v1/cart` and `/api/v1/orders` (see
/// CartController/OrderController). The cart *is* the customer's DRAFT order.
class OrderService {
  final ApiClient _client = ApiClient.instance;

  Future<OrderDto> getCart() => _client.get('/cart', (json) => OrderDto.fromJson(json as Map<String, dynamic>));

  Future<OrderDto> addItem(String productId, int quantity) => _client.post(
        '/cart/items',
        {'productId': productId, 'quantity': quantity},
        (json) => OrderDto.fromJson(json as Map<String, dynamic>),
      );

  Future<OrderDto> updateItemQuantity(String itemId, int quantity) => _client.put(
        '/cart/items/$itemId',
        {'quantity': quantity},
        (json) => OrderDto.fromJson(json as Map<String, dynamic>),
      );

  Future<OrderDto> removeItem(String itemId) => _client.delete(
        '/cart/items/$itemId',
        (json) => OrderDto.fromJson(json as Map<String, dynamic>),
      );

  Future<OrderDto> checkout({
    required String shippingAddressId,
    required String paymentMethod,
    required String idempotencyKey,
  }) =>
      _client.post(
        '/orders/checkout',
        {'shippingAddressId': shippingAddressId, 'paymentMethod': paymentMethod},
        (json) => OrderDto.fromJson(json as Map<String, dynamic>),
        extraHeaders: {'Idempotency-Key': idempotencyKey},
      );

  Future<OrderDto> pay(String orderId) => _client.post(
        '/orders/$orderId/pay',
        null,
        (json) => OrderDto.fromJson(json as Map<String, dynamic>),
      );

  Future<int> countOrders() => _client.get(
        '/orders?page=0&size=1',
        (json) => (json as Map<String, dynamic>)['totalElements'] as int,
      );
}
