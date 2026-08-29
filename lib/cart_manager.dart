import 'package:flutter/material.dart';

import 'api_models.dart';
import 'order_service.dart';
import 'wallet_service.dart';

/// Cart state backed by nexalink-api's `/api/v1/cart` (a DRAFT `orders` row —
/// see order_service.dart) plus the real wallet balance from `/api/v1/wallet`
/// (see wallet_service.dart). Coupon code stays local/cosmetic: the backend has
/// no coupon module (only wallet + referral shipped in M3), so it doesn't affect
/// the amount actually charged at checkout — only the on-screen estimate.
///
/// "Use wallet balance" is real, but only in the all-or-nothing case: if the
/// wallet fully covers the order subtotal, checkout pays with the WALLET
/// payment method (see checkout_page.dart), which really debits the ledger.
/// Partial wallet + another payment method in the same order isn't something
/// nexalink-api's single-`PaymentMethod`-per-order model supports, so a wallet
/// balance that only partially covers the order just shows the estimate.
class CartNotifier extends ChangeNotifier {
  static const double cashbackRate = 0.02;
  static const String validCoupon = 'NEXA100';
  static const double couponDiscount = 100.0;

  final OrderService _orderService = OrderService();
  final WalletService _walletService = WalletService();

  OrderDto? _order;
  double walletBalance = 0.0;
  bool isLoading = false;
  String? loadError;
  String? appliedCoupon;
  bool useWallet = false;

  OrderDto? get order => _order;

  int get quantity => _order?.items.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;

  double get subtotal => _order?.totalAmount ?? 0.0;

  double get discount => appliedCoupon == validCoupon ? couponDiscount : 0.0;

  double get walletDeduction {
    if (!useWallet) return 0.0;
    final remaining = subtotal - discount;
    return remaining < walletBalance ? remaining : walletBalance;
  }

  double get total => subtotal - discount - walletDeduction;

  double get estimatedCashback => subtotal * cashbackRate;

  /// Whether the wallet balance alone covers the real order subtotal (ignoring
  /// the cosmetic coupon discount) — the condition under which checkout can
  /// actually pay with the WALLET method. See the class doc.
  bool get walletFullyCoversOrder => useWallet && subtotal > 0 && walletBalance >= subtotal;

  Future<void> loadCart() async {
    isLoading = true;
    loadError = null;
    notifyListeners();
    try {
      final results = await Future.wait([_orderService.getCart(), _walletService.getBalance()]);
      _order = results[0] as OrderDto;
      walletBalance = (results[1] as WalletBalance).balance;
    } catch (e) {
      loadError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWalletBalance() async {
    try {
      walletBalance = (await _walletService.getBalance()).balance;
      notifyListeners();
    } catch (_) {
      // best-effort refresh; keep the last known balance on failure
    }
  }

  Future<void> addToCart(String productId) async {
    isLoading = true;
    notifyListeners();
    try {
      _order = await _orderService.addItem(productId, 1);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setQuantity(String productId, int value) async {
    final clamped = value.clamp(0, 10);
    final item = _order?.items.where((i) => i.productId == productId).firstOrNull;
    if (item == null) return;
    isLoading = true;
    notifyListeners();
    try {
      _order = clamped == 0 ? await _orderService.removeItem(item.id) : await _orderService.updateItemQuantity(item.id, clamped);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool applyCoupon(String code) {
    final trimmed = code.trim().toUpperCase();
    final valid = trimmed == validCoupon;
    appliedCoupon = valid ? trimmed : null;
    notifyListeners();
    return valid;
  }

  void setUseWallet(bool value) {
    useWallet = value;
    notifyListeners();
  }

  void clear() {
    _order = null;
    appliedCoupon = null;
    useWallet = false;
    notifyListeners();
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class CartProvider extends InheritedNotifier<CartNotifier> {
  const CartProvider({required CartNotifier notifier, required Widget child, super.key}) : super(notifier: notifier, child: child);

  static CartNotifier of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found in context');
    return provider!.notifier!;
  }
}
