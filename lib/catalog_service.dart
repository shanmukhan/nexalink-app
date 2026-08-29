import 'api_client.dart';
import 'api_models.dart';

/// Wraps nexalink-api's read-only `/api/v1/products` (see ProductController).
/// MVP ships with exactly one sellable product (docs/09_Project_Roadmap.md),
/// so [fetchMvpProduct] just takes the first page's first result.
class CatalogService {
  final ApiClient _client = ApiClient.instance;

  Future<ProductDetail> fetchMvpProduct() async {
    final summaries = await _client.get<List<ProductSummary>>(
      '/products?page=0&size=1',
      (json) => ((json as Map<String, dynamic>)['content'] as List<dynamic>)
          .map((e) => ProductSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (summaries.isEmpty) {
      throw ApiException('NO_PRODUCTS', 'No products available yet');
    }
    return fetchProduct(summaries.first.id);
  }

  Future<ProductDetail> fetchProduct(String productId) => _client.get(
        '/products/$productId',
        (json) => ProductDetail.fromJson(json as Map<String, dynamic>),
      );
}
