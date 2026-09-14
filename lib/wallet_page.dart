import 'package:flutter/material.dart';
import 'api_client.dart';
import 'api_models.dart';
import 'cart_manager.dart';
import 'generated/app_localizations.dart';
import 'wallet_service.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  static const int _pageSize = 20;

  final _walletService = WalletService();

  WalletBalance? _balance;
  final List<WalletTransactionEntry> _transactions = [];
  int _nextPage = 0;
  bool _hasMore = true;

  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _walletService.getBalance(),
        _walletService.listTransactions(page: 0, size: _pageSize),
      ]);
      if (!mounted) return;
      setState(() {
        _balance = results[0] as WalletBalance;
        _transactions
          ..clear()
          ..addAll(results[1] as List<WalletTransactionEntry>);
        _nextPage = 1;
        _hasMore = (results[1] as List<WalletTransactionEntry>).length == _pageSize;
      });
      if (mounted) {
        // Keep the shared cart/wallet balance in sync for the home dashboard card.
        await CartProvider.of(context).refreshWalletBalance();
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = S.of(context)!.walletLoadFailed);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final page = await _walletService.listTransactions(page: _nextPage, size: _pageSize);
      if (!mounted) return;
      setState(() {
        _transactions.addAll(page);
        _nextPage++;
        _hasMore = page.length == _pageSize;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _showWithdrawalDialog() async {
    final l10n = S.of(context)!;
    final balance = _balance?.balance ?? 0.0;
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final amount = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.withdrawalDialogTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  l10n.withdrawalDialogSubtitle('₹ ${balance.toStringAsFixed(2)}'),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.withdrawalAmountLabel,
                    hintText: l10n.withdrawalAmountHint,
                    prefixText: '₹ ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return l10n.withdrawalAmountRequired;
                    final parsed = double.tryParse(text);
                    if (parsed == null || parsed <= 0) return l10n.withdrawalAmountInvalid;
                    if (parsed > balance) return l10n.withdrawalAmountExceedsBalance;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(l10n.cancelButton),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() != true) return;
                          Navigator.of(sheetContext).pop(double.parse(controller.text.trim()));
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(l10n.submitButton),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (amount == null) return;
    await _submitWithdrawal(amount);
  }

  Future<void> _submitWithdrawal(double amount) async {
    final l10n = S.of(context)!;
    try {
      await _walletService.requestWithdrawal(amount);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.withdrawalSubmitted)));
      await _load();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.withdrawalFailed)));
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} ${two(local.hour)}:${two(local.minute)}';
  }

  Widget _buildTransactionTile(WalletTransactionEntry entry, S l10n) {
    final isCredit = entry.type.toUpperCase() == 'CREDIT';
    final color = isCredit ? Colors.green : Colors.redAccent;
    final sign = isCredit ? '+' : '-';
    final typeLabel = isCredit ? l10n.transactionTypeCredit : l10n.transactionTypeDebit;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.reason, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('$typeLabel · ${_formatDate(entry.createdAt)}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(
            '$sign₹ ${entry.amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context)!;
    final currency = _balance?.currency ?? 'INR';
    final balanceValue = _balance?.balance ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FF),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(l10n.walletPageTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!, style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          FilledButton(onPressed: _load, child: Text(l10n.retryLabel)),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (_hasMore &&
                            !_isLoadingMore &&
                            notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
                          _loadMore();
                        }
                        return false;
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF5B46FF), Color(0xFF6D81FF)]),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(color: Colors.indigo.withAlpha(41), blurRadius: 25, offset: const Offset(0, 12)),
                              ],
                            ),
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.currentBalance, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 12),
                                Text(
                                  '${currency == 'INR' ? '₹' : currency} ${balanceValue.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _showWithdrawalDialog,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.indigo),
                                    label: Text(l10n.requestWithdrawal, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(l10n.transactionHistory, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 14),
                          if (_transactions.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(l10n.noTransactionsYet, style: const TextStyle(color: Colors.black54)),
                              ),
                            )
                          else ...[
                            for (final entry in _transactions) _buildTransactionTile(entry, l10n),
                            if (_isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            else if (_hasMore)
                              Center(
                                child: TextButton(
                                  onPressed: _loadMore,
                                  child: Text(l10n.loadMore),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
