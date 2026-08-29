import 'package:flutter/material.dart';
import 'api_models.dart';
import 'generated/app_localizations.dart';
import 'home_page.dart';

class OrderConfirmationPage extends StatelessWidget {
  final OrderDto order;

  const OrderConfirmationPage({required this.order, super.key});

  static const _statusOrder = ['PENDING', 'PAID', 'PACKED', 'SHIPPED', 'DELIVERED'];

  Widget _buildStatusStep({required IconData icon, required String label, required bool isDone, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDone ? Colors.indigo : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: isDone ? Colors.white : Colors.black38),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: isDone ? Colors.indigo : Colors.grey.shade200)),
            ],
          ),
          const SizedBox(width: 14),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 24),
            child: Text(label, style: TextStyle(fontWeight: isDone ? FontWeight.bold : FontWeight.normal, color: isDone ? Colors.black87 : Colors.black38)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final currentStepIndex = _statusOrder.indexOf(order.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: Colors.green.withAlpha(25), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 56),
              ),
              const SizedBox(height: 20),
              Text(l10n.orderPlacedTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.orderPlacedSubtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 6),
              Text(l10n.orderIdLabel(order.id.substring(0, 8).toUpperCase()), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600)),
              if (order.invoiceNumber != null) ...[
                const SizedBox(height: 4),
                Text(order.invoiceNumber!, style: const TextStyle(color: Colors.black45, fontSize: 12)),
              ],
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 18, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusStep(icon: Icons.shopping_bag_outlined, label: l10n.statusPlaced, isDone: currentStepIndex >= 0, isLast: false),
                    _buildStatusStep(icon: Icons.payments_outlined, label: l10n.statusPaid, isDone: currentStepIndex >= 1, isLast: false),
                    _buildStatusStep(icon: Icons.inventory_2_outlined, label: l10n.statusPacked, isDone: currentStepIndex >= 2, isLast: false),
                    _buildStatusStep(icon: Icons.local_shipping_outlined, label: l10n.statusShipped, isDone: currentStepIndex >= 3, isLast: false),
                    _buildStatusStep(icon: Icons.home_outlined, label: l10n.statusDelivered, isDone: currentStepIndex >= 4, isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  },
                  child: Text(l10n.continueShopping),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
