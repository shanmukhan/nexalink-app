import 'package:flutter/material.dart';
import 'cart_manager.dart';
import 'checkout_page.dart';
import 'generated/app_localizations.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 14, offset: const Offset(0, 8)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isBold ? 15 : 13, color: isBold ? Colors.black87 : Colors.black54, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: isBold ? 16 : 13, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context)!;
    final cart = CartProvider.of(context);
    String currency(double value) => '₹ ${value.toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FF),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(l10n.cartTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: cart,
          builder: (context, _) {
            if (cart.isLoading && cart.order == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = cart.order?.items ?? const [];
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.black26),
                      const SizedBox(height: 16),
                      Text(l10n.cartEmptyTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(l10n.cartEmptySubtitle, style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.browseProducts),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final item in items)
                    _buildCard(
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF5B46FF), Color(0xFF6D81FF)]),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.tv_outlined, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Text(currency(item.unitPrice), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.indigo,
                                onPressed: cart.isLoading ? null : () => cart.setQuantity(item.productId, item.quantity - 1),
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.indigo,
                                onPressed: cart.isLoading ? null : () => cart.setQuantity(item.productId, item.quantity + 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.couponCodeLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                textCapitalization: TextCapitalization.characters,
                                decoration: InputDecoration(
                                  hintText: l10n.couponCodeHint,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () {
                                final applied = cart.applyCoupon(_couponController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(applied ? l10n.couponApplied : l10n.invalidCoupon)),
                                );
                              },
                              child: Text(l10n.applyCoupon),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.useWalletBalance, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(l10n.walletAvailable(currency(cart.walletBalance)), style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ),
                        Switch(value: cart.useWallet, activeThumbColor: Colors.indigo, onChanged: cart.setUseWallet),
                      ],
                    ),
                  ),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(l10n.orderSummary, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 10),
                        _buildSummaryRow(l10n.subtotal, currency(cart.subtotal)),
                        if (cart.discount > 0) _buildSummaryRow(l10n.couponDiscountLabel, '- ${currency(cart.discount)}', valueColor: Colors.green),
                        if (cart.walletDeduction > 0) _buildSummaryRow(l10n.walletApplied, '- ${currency(cart.walletDeduction)}', valueColor: Colors.green),
                        _buildSummaryRow(l10n.estimatedCashbackLabel, currency(cart.estimatedCashback), valueColor: Colors.indigo),
                        const Divider(height: 20),
                        _buildSummaryRow(l10n.totalLabel, currency(cart.total), isBold: true),
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: cart.isLoading ? null : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutPage())),
                    child: Text(l10n.proceedToCheckout),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
