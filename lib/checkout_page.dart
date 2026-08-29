import 'dart:math';

import 'package:flutter/material.dart';
import 'address_service.dart';
import 'api_client.dart';
import 'api_models.dart';
import 'cart_manager.dart';
import 'generated/app_localizations.dart';
import 'order_confirmation_page.dart';
import 'order_service.dart';

enum PaymentMethod { upi, card, cod }

extension on PaymentMethod {
  String get apiValue => switch (this) {
        PaymentMethod.upi => 'UPI',
        PaymentMethod.card => 'CARD',
        PaymentMethod.cod => 'COD',
      };
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressService = AddressService();
  final _orderService = OrderService();

  PaymentMethod _paymentMethod = PaymentMethod.upi;
  bool _needsGstInvoice = false;
  final _gstinController = TextEditingController();

  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  bool _isLoadingAddresses = true;
  bool _isPlacingOrder = false;
  bool _isSavingAddress = false;
  String? _errorMessage;
  List<Address> _addresses = [];
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoadingAddresses = true);
    try {
      final addresses = await _addressService.listAddresses();
      if (!mounted) return;
      setState(() {
        _addresses = addresses;
        _selectedAddress = addresses.where((a) => a.isDefault).cast<Address?>().firstOrNull ?? addresses.firstOrNull;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoadingAddresses = false);
    }
  }

  Future<void> _saveAddress() async {
    if (_line1Controller.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _stateController.text.trim().isEmpty ||
        _postalCodeController.text.trim().isEmpty) {
      return;
    }
    setState(() => _isSavingAddress = true);
    try {
      final address = await _addressService.addAddress(
        type: 'HOME',
        line1: _line1Controller.text.trim(),
        line2: _line2Controller.text.trim().isEmpty ? null : _line2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        isDefault: _addresses.isEmpty,
      );
      if (!mounted) return;
      setState(() {
        _addresses = [..._addresses, address];
        _selectedAddress = address;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isSavingAddress = false);
    }
  }

  Future<void> _placeOrder() async {
    final address = _selectedAddress;
    if (address == null) return;
    setState(() {
      _isPlacingOrder = true;
      _errorMessage = null;
    });
    try {
      final cart = CartProvider.of(context);
      final paymentMethod = cart.walletFullyCoversOrder ? 'WALLET' : _paymentMethod.apiValue;
      final idempotencyKey = _randomKey();
      final checkedOut = await _orderService.checkout(
        shippingAddressId: address.id,
        paymentMethod: paymentMethod,
        idempotencyKey: idempotencyKey,
      );
      final paid = await _orderService.pay(checkedOut.id);
      if (!mounted) return;
      await cart.refreshWalletBalance();
      cart.clear();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OrderConfirmationPage(order: paid)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  String _randomKey() {
    final rand = Random.secure();
    return List.generate(24, (_) => rand.nextInt(16).toRadixString(16)).join();
  }

  @override
  void dispose() {
    _gstinController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
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

  Widget _buildPaymentTile({required PaymentMethod method, required IconData icon, required String label}) {
    final selected = _paymentMethod == method;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.indigo.withAlpha(20) : const Color(0xFFF7F9FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? Colors.indigo : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.indigo : Colors.black54, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? Colors.indigo : Colors.black87))),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? Colors.indigo : Colors.black26, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(S l10n) {
    if (_isLoadingAddresses) {
      return _buildCard(child: const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator())));
    }
    if (_selectedAddress != null) {
      final address = _selectedAddress!;
      return _buildCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.indigo.withAlpha(20), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.location_on_outlined, color: Colors.indigo),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.deliveryAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(address.displayLine, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.addAddressTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(controller: _line1Controller, decoration: InputDecoration(hintText: l10n.addressLine1Hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), isDense: true)),
          const SizedBox(height: 10),
          TextField(controller: _line2Controller, decoration: InputDecoration(hintText: l10n.addressLine2Hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), isDense: true)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: TextField(controller: _cityController, decoration: InputDecoration(hintText: l10n.cityHint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), isDense: true))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _stateController, decoration: InputDecoration(hintText: l10n.stateHint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), isDense: true))),
            ],
          ),
          const SizedBox(height: 10),
          TextField(controller: _postalCodeController, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: l10n.postalCodeHint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), isDense: true)),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _isSavingAddress ? null : _saveAddress,
            child: _isSavingAddress ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(l10n.saveAddressButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final cart = CartProvider.of(context);
    String currency(double value) => '₹ ${value.toStringAsFixed(2)}';
    final canPlaceOrder = _selectedAddress != null && !_isPlacingOrder;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FF),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(l10n.checkoutTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddressSection(l10n),
              if (cart.walletFullyCoversOrder)
                _buildCard(
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet, color: Colors.indigo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(l10n.walletFullyCoversOrder, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                )
              else
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    _buildPaymentTile(method: PaymentMethod.upi, icon: Icons.qr_code_scanner, label: l10n.paymentUpi),
                    _buildPaymentTile(method: PaymentMethod.card, icon: Icons.credit_card, label: l10n.paymentCard),
                    _buildPaymentTile(method: PaymentMethod.cod, icon: Icons.payments_outlined, label: l10n.paymentCod),
                  ],
                ),
              ),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.gstInvoice, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Switch(value: _needsGstInvoice, activeThumbColor: Colors.indigo, onChanged: (v) => setState(() => _needsGstInvoice = v)),
                      ],
                    ),
                    if (_needsGstInvoice) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: _gstinController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: l10n.gstinLabel,
                          hintText: l10n.gstinHint,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.orderSummary, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.totalLabel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(currency(cart.total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
              ],
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: canPlaceOrder ? _placeOrder : null,
                child: _isPlacingOrder
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(l10n.placeOrder),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
