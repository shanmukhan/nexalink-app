import 'package:flutter/material.dart';
import 'api_models.dart';
import 'cart_manager.dart';
import 'generated/app_localizations.dart';
import 'order_service.dart';
import 'product_page.dart';
import 'profile_page.dart';
import 'referral_service.dart';
import 'teams_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _buildTabContents(BuildContext context) => <Widget>[
        const HomeDashboard(),
        const ProductPage(),
        const TeamsPage(),
        Center(child: Text(S.of(context)!.earningsComingSoon, style: const TextStyle(fontSize: 16))),
        const ProfilePage(),
      ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      body: SafeArea(
        child: _buildTabContents(context)[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: S.of(context)!.home),
          NavigationDestination(icon: const Icon(Icons.storefront_outlined), selectedIcon: const Icon(Icons.storefront), label: S.of(context)!.shop),
          NavigationDestination(icon: const Icon(Icons.group_outlined), selectedIcon: const Icon(Icons.group), label: S.of(context)!.teams),
          NavigationDestination(icon: const Icon(Icons.bar_chart_outlined), selectedIcon: const Icon(Icons.bar_chart), label: S.of(context)!.earnings),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: S.of(context)!.profile),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final _orderService = OrderService();
  final _referralService = ReferralService();
  int? _orderCount;
  int? _teamCount;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final orderCount = await _orderService.countOrders();
      final ReferralSummary summary = await _referralService.getMySummary();
      if (!mounted) return;
      setState(() {
        _orderCount = orderCount;
        _teamCount = summary.referredCount;
      });
    } catch (_) {
      // best-effort dashboard stats; leave placeholders on failure
    }
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value, Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? Colors.indigo).withAlpha(31),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color ?? Colors.indigo, size: 22),
            ),
            const SizedBox(height: 18),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.indigo, size: 26),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context)!;
    final walletBalance = CartProvider.of(context).walletBalance;
    final orderCountLabel = _orderCount?.toString() ?? '—';
    final teamCountLabel = _teamCount?.toString() ?? '—';

    return SingleChildScrollView(
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
                    Text(l10n.greeting('Shanmukhan'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(l10n.welcomeBack, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.indigo.shade50,
                child: const Icon(Icons.person, color: Colors.indigo),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.totalWalletBalance, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(l10n.addMoney, style: const TextStyle(color: Colors.indigo)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text('₹ ${walletBalance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _buildMiniStat(l10n.totalEarnings, '₹ 45,680')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildMiniStat(l10n.thisMonth, '₹ 8,750')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildMiniStat(l10n.pendingPayout, '₹ 2,350')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _buildInfoCard(icon: Icons.shopping_bag_outlined, title: l10n.myOrders, value: orderCountLabel, color: Colors.blue),
              const SizedBox(width: 12),
              _buildInfoCard(icon: Icons.group_outlined, title: l10n.myTeam, value: teamCountLabel, color: Colors.purple),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildInfoCard(icon: Icons.account_balance_wallet_outlined, title: l10n.walletLabel, value: '₹ ${walletBalance.toStringAsFixed(2)}', color: Colors.teal),
              const SizedBox(width: 12),
              _buildInfoCard(icon: Icons.card_giftcard_outlined, title: l10n.rewards, value: '33', color: Colors.orange),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 18, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.megaOffer, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                        SizedBox(height: 6),
                        Text(l10n.offerProduct, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withAlpha(31),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.local_offer_outlined, color: Colors.indigo),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.offerStartingAt, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductPage())),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(l10n.shopNow),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.topCategories, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(l10n.viewAll, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.indigo)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCategoryTile(icon: Icons.tv_outlined, label: l10n.televisions),
              const SizedBox(width: 12),
              _buildCategoryTile(icon: Icons.phone_iphone_outlined, label: l10n.mobiles),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCategoryTile(icon: Icons.kitchen_outlined, label: l10n.appliances),
              const SizedBox(width: 12),
              _buildCategoryTile(icon: Icons.headphones_outlined, label: l10n.accessories),
            ],
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(230),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
