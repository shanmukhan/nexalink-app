import 'api_client.dart';
import 'api_models.dart';

/// Wraps nexalink-api's `/api/v1/wallet` (see wallet.api.WalletController). Ledger
/// balance is always derived server-side (sum(CREDIT) - sum(DEBIT)) — there's no
/// mutable "balance" to write here.
class WalletService {
  final ApiClient _client = ApiClient.instance;

  Future<WalletBalance> getBalance() => _client.get('/wallet', (json) => WalletBalance.fromJson(json as Map<String, dynamic>));

  Future<List<WalletTransactionEntry>> listTransactions({int page = 0, int size = 20}) => _client.get(
        '/wallet/transactions?page=$page&size=$size',
        (json) => ((json as Map<String, dynamic>)['content'] as List<dynamic>)
            .map((e) => WalletTransactionEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Future<void> requestWithdrawal(double amount) => _client.post<void>(
        '/wallet/withdrawals',
        {'amount': amount},
        (_) {},
      );

  /// Wraps `/api/v1/reporting/earnings-summary` (see
  /// reporting.api.ReportingController). Lives here rather than a separate
  /// ReportingService since the data is wallet-derived and this is the only
  /// consumer so far.
  Future<EarningsSummary> getEarningsSummary() =>
      _client.get('/reporting/earnings-summary', (json) => EarningsSummary.fromJson(json as Map<String, dynamic>));
}
