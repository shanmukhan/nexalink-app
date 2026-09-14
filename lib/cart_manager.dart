import 'package:flutter/material.dart';

import 'api_client.dart';
import 'api_models.dart';
import 'coupon_service.dart';
import 'order_service.dart';
import 'wallet_service.dart';

/// Cart state backed by nexalink-api's `/api/v1/cart` (a DRAFT `orders` row —
/// see order_service.dart) plus the real wallet balance from `/api/v1/wallet`
/// (see wallet_service.dart). Coupon validation now round-trips to
/// `/api/v1/coupons/validate` (see coupon_service.dart) for the on-screen
/// preview, and the same code is sent through on `/orders/checkout` — the
/// backend re-validates it there unconditionally and that's what actually
/// reduces the amount charged (see nexalink-api's
/// coupon.application.CouponService and order.application.OrderService#checkout).
///
/// "Use wallet balance" is real, but only in the all-or-nothing case: if the
/// wallet fully covers the order subtotal, checkout pays with the WALLET
/// payment method (see checkout_page.dart), which really debits the ledger.
/// Partial wallet + another payment method in the same order isn't something
/// nexalink-api's single-`PaymentMethod`-per-order model supports, so a wallet
/// balance that only partially covers the order just shows the estimate.
class CartNotifier extends ChangeNotifier {
  static const double cashbackRate = 0.02;

  final OrderService _orderService = OrderService();
  final WalletService _walletService = WalletService();
  final CouponService _couponService = CouponService();

  OrderDto? _order;
  double walletBalance = 0.0;
  bool isLoading = false;
  String? loadError;
  String? appliedCoupon;
  double _appliedCouponDiscount = 0.0;
  bool isApplyingCoupon = false;
  String? couponError;
  bool useWallet = false;

  OrderDto? get order => _order;

  int get quantity => _order?.items.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;

  double get subtotal => _order?.totalAmount ?? 0.0;

  /// Discount from the last successful [applyCoupon] preview. Not a client-side
  /// computation; the backend is the source of truth for both the preview and
  /// the re-validated amount actually applied at checkout.
  double get discount => appliedCoupon != null ? _appliedCouponDiscount : 0.0;

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

  /// Validates the coupon against `/api/v1/coupons/validate` (a preview only —
  /// no redemption is recorded server-side; see coupon_service.dart) and, on
  /// success, stores the server-computed discount for [discount]/[total] to use.
  /// Returns true on success; on failure, [appliedCoupon] is cleared and
  /// [couponError] carries a message the UI can show.
  Future<bool> applyCoupon(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return false;
    isApplyingCoupon = true;
    couponError = null;
    notifyListeners();
    try {
      final result = await _couponService.validate(code: trimmed, orderTotal: subtotal);
      appliedCoupon = result.code;
      _appliedCouponDiscount = result.discountAmount;
      return true;
    } on ApiException catch (e) {
      appliedCoupon = null;
      _appliedCouponDiscount = 0.0;
      couponError = e.message;
      return false;
    } finally {
      isApplyingCoupon = false;
      notifyListeners();
    }
  }

  void removeCoupon() {
    appliedCoupon = null;
    _appliedCouponDiscount = 0.0;
    couponError = null;
    notifyListeners();
  }

  void setUseWallet(bool value) {
    useWallet = value;
    notifyListeners();
  }

  void clear() {
    _order = null;
    appliedCoupon = null;
    _appliedCouponDiscount = 0.0;
    couponError = null;
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
