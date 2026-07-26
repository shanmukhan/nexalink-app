import 'package:flutter/material.dart';
import 'generated/app_localizations.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  Widget _buildMemberCard({required String name, required String role, required String status, required Color color}) {
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
            child: Text(name[0], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(role, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionLine({required bool isLast}) {
    return Container(
      width: 30,
      margin: const EdgeInsets.only(left: 38),
      child: Column(
        children: [
          Container(width: 2, height: 20, color: Colors.grey.withAlpha(80)),
          if (!isLast)
            Container(width: 2, height: 40, color: Colors.grey.withAlpha(80)),
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
              Text(l10n.myTeamTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(l10n.teamTreeSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 18, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMemberCard(name: l10n.currentUser, role: l10n.currentUser, status: l10n.currentUser, color: Colors.indigo),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(radius: 6, backgroundColor: Colors.indigo),
                            SizedBox(height: 110),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              _buildMemberCard(name: 'Amit Sharma', role: 'Level 1', status: l10n.active, color: Colors.purple),
                              _buildConnectionLine(isLast: false),
                              _buildMemberCard(name: 'Neha Patel', role: 'Level 1', status: l10n.active, color: Colors.teal),
                              _buildConnectionLine(isLast: false),
                              _buildMemberCard(name: 'Vikram Reddy', role: 'Level 1', status: l10n.active, color: Colors.orange),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                                Text(l10n.teamSize, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 16, offset: Offset(0, 8)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.activeTeam, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                const SizedBox(height: 10),
                                Text(l10n.activeTeamCount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 16, offset: Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.businessVolume, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                          const SizedBox(height: 10),
                          Text(l10n.businessVolumeValue, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
