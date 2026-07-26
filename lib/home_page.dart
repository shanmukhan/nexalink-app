import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'teams_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _tabContents = <Widget>[
    const HomeDashboard(),
    const Center(child: Text('Shop coming soon', style: TextStyle(fontSize: 16))),
    const TeamsPage(),
    const Center(child: Text('Earnings details coming soon', style: TextStyle(fontSize: 16))),
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
        child: _tabContents[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: 'Teams'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Earnings'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

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
                    Text('Hi, Shanmukhan 👋', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Welcome back', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
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
                    const Text('Total Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Add Money', style: TextStyle(color: Colors.indigo)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text('₹ 12,450.50', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _buildMiniStat('Total Earnings', '₹ 45,680')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildMiniStat('This Month', '₹ 8,750')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildMiniStat('Pending Payout', '₹ 2,350')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _buildInfoCard(icon: Icons.shopping_bag_outlined, title: 'My Orders', value: '12', color: Colors.blue),
              const SizedBox(width: 12),
              _buildInfoCard(icon: Icons.group_outlined, title: 'My Team', value: '8', color: Colors.purple),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildInfoCard(icon: Icons.account_balance_wallet_outlined, title: 'Wallet', value: '₹ 12,450', color: Colors.teal),
              const SizedBox(width: 12),
              _buildInfoCard(icon: Icons.card_giftcard_outlined, title: 'Rewards', value: '33', color: Colors.orange),
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
                      children: const [
                        Text('Mega Offer', style: TextStyle(fontSize: 13, color: Colors.black54)),
                        SizedBox(height: 6),
                        Text('55" 4K LED TV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                const Text('Starting at ₹ 29,999', style: TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Shop Now'),
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
              Text('Top Categories', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text('View All', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.indigo)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCategoryTile(icon: Icons.tv_outlined, label: 'Televisions'),
              const SizedBox(width: 12),
              _buildCategoryTile(icon: Icons.phone_iphone_outlined, label: 'Mobiles'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCategoryTile(icon: Icons.kitchen_outlined, label: 'Appliances'),
              const SizedBox(width: 12),
              _buildCategoryTile(icon: Icons.headphones_outlined, label: 'Accessories'),
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
