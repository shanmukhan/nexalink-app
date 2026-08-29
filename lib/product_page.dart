import 'package:flutter/material.dart';
import 'api_client.dart';
import 'api_models.dart';
import 'cart_manager.dart';
import 'cart_page.dart';
import 'catalog_service.dart';
import 'generated/app_localizations.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _catalogService = CatalogService();
  ProductDetail? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final product = await _catalogService.fetchMvpProduct();
      if (!mounted) return;
      setState(() => _product = product);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildInfoSection({required BuildContext context, required IconData icon, required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 14, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.indigo, size: 20),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.indigo),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context)!;
    final cart = CartProvider.of(context);

    if (_isLoading) {
      return const Scaffold(backgroundColor: Color(0xFFF7F9FF), body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _product == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9FF),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.productLoadFailed, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              FilledButton(onPressed: _loadProduct, child: Text(l10n.retryLabel)),
            ],
          ),
        ),
      );
    }

    final product = _product!;
    final currency = '₹ ${product.price.toStringAsFixed(0)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.indigo),
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartPage())),
                            ),
                          ),
                          if (cart.quantity > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                child: Text('${cart.quantity}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF5B46FF), Color(0xFF6D81FF)]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.tv_outlined, color: Colors.white, size: 96),
                  ),
                  const SizedBox(height: 20),
                  Text(product.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text(l10n.productRating, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(currency, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const SizedBox(height: 20),
                  if (product.specifications.isNotEmpty)
                    _buildInfoSection(
                      context: context,
                      icon: Icons.list_alt_outlined,
                      title: l10n.specifications,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: product.specifications.entries.map((e) => _buildSpecRow('${e.key}: ${e.value}')).toList(),
                      ),
                    ),
                  if (product.warrantyMonths != null)
                    _buildInfoSection(
                      context: context,
                      icon: Icons.verified_outlined,
                      title: l10n.warrantyTitle,
                      content: Text('${product.warrantyMonths} months warranty', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    ),
                  _buildInfoSection(
                    context: context,
                    icon: Icons.account_balance_wallet_outlined,
                    title: l10n.cashbackEligibility,
                    content: Text(l10n.cashbackText, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ),
                  _buildInfoSection(
                    context: context,
                    icon: Icons.group_add_outlined,
                    title: l10n.referralPolicy,
                    content: Text(l10n.referralPolicyText, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ),
                  _buildInfoSection(
                    context: context,
                    icon: Icons.grid_view_outlined,
                    title: l10n.similarProducts,
                    content: Text(l10n.similarProductsComingSoon, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 16, offset: const Offset(0, -4))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await cart.addToCart(product.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addToCart)));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(l10n.addToCart),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await cart.addToCart(product.id);
                          if (!context.mounted) return;
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartPage()));
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(l10n.buyNow),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
