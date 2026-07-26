import 'package:flutter/material.dart';
import 'generated/app_localizations.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildOptionTile({required IconData icon, required String title, String? subtitle}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.indigo, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black26),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.profileTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(l10n.profileSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                      ],
                    ),
                  ),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.settings, color: Colors.indigo),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 18, offset: const Offset(0, 10)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withAlpha(20),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(Icons.person, size: 38, color: Colors.indigo),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Shanmukhan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('shanmukhan.b@gmail.com', style: TextStyle(fontSize: 14, color: Colors.black54)),
                          SizedBox(height: 4),
                          Text('9160151567', style: TextStyle(fontSize: 14, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(icon: Icons.badge_outlined, title: l10n.personalInformation),
              _buildOptionTile(icon: Icons.verified_user_outlined, title: l10n.kycVerification, subtitle: l10n.verified),
              _buildOptionTile(icon: Icons.account_balance_outlined, title: l10n.bankDetails),
              _buildOptionTile(icon: Icons.lock_outline, title: l10n.changePassword),
              _buildOptionTile(icon: Icons.bookmark_border, title: l10n.addressBook),
              _buildOptionTile(icon: Icons.support_agent_outlined, title: l10n.supportHelp),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  child: Text(l10n.logout, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
