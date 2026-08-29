import 'api_client.dart';
import 'api_models.dart';

/// Wraps nexalink-api's `/api/v1/wallet` (see wallet.api.WalletController). Ledger
/// balance is always derived server-side (sum(CREDIT) - sum(DEBIT)) — there's no
/// mutable "balance" to write here.
class WalletService {
  final ApiClient _client = ApiClient.instance;

  Future<WalletBalance> getBalance() => _client.get('/wallet', (json) => WalletBalance.fromJson(json as Map<String, dynamic>));

  Future<List<WalletTransactionEntry>> listTransactions() => _client.get(
        '/wallet/transactions?page=0&size=50',
        (json) => ((json as Map<String, dynamic>)['content'] as List<dynamic>)
            .map((e) => WalletTransactionEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Future<void> requestWithdrawal(double amount) => _client.post<void>(
        '/wallet/withdrawals',
        {'amount': amount},
        (_) {},
      );
}
