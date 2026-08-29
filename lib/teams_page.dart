import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_client.dart';
import 'api_models.dart';
import 'generated/app_localizations.dart';
import 'referral_service.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final _referralService = ReferralService();
  ReferralSummary? _summary;
  bool _isLoading = true;
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
      final summary = await _referralService.getMySummary();
      if (!mounted) return;
      setState(() => _summary = summary);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildMemberCard({required String name, required String subtitle, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withAlpha(25),
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.myTeamTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(l10n.teamTreeSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                const SizedBox(height: 22),
                if (_isLoading)
                  const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
                else if (_error != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(_error!, style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 12),
                          FilledButton(onPressed: _load, child: Text(l10n.retryLabel)),
                        ],
                      ),
                    ),
                  )
                else if (_summary != null)
                  _buildSummary(context, l10n, _summary!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, S l10n, ReferralSummary summary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 18, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.myReferralCode, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(summary.referralCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.indigo)),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: summary.referralCode));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.referralCodeCopied)));
                },
                icon: const Icon(Icons.copy, size: 16),
                label: Text(l10n.shareCode),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(l10n.referralsUsed(summary.referredCount, summary.maxReferrals), style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 20),
          if (summary.referees.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(l10n.noReferralsYet, style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center),
            )
          else
            for (final referee in summary.referees)
              _buildMemberCard(
                name: referee.displayName,
                subtitle: l10n.active,
                color: Colors.purple,
              ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withAlpha(15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.totalTeam, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                      const SizedBox(height: 10),
                      Text('${summary.referredCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 16, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.commissionEarned, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                      const SizedBox(height: 10),
                      Text('₹ ${summary.totalCommissionEarned.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
