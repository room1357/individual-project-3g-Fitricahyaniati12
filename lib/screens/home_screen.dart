import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'advanced_expense_list_screen.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';
import 'category_screen.dart';
import 'settings_screen.dart';
import 'shared_expenses_screen.dart';
import 'currency_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('loggedInUser') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 212, 227),
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(
            color: Color(0xFF24527A),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF7EC8E3),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFFFAFAFA),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF7EC8E3)),
              accountName: Text(
                username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('fitri@example.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xFF24527A)),
              ),
            ),
            _buildDrawerItem(Icons.person, 'Profil', () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              _loadUsername(); // ⬅️ Refresh setelah kembali
            }),
            _buildDrawerItem(Icons.settings, 'Pengaturan', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
            const Divider(),
            _buildDrawerItem(Icons.logout, 'Keluar', () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('loggedInUser');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }, color: Colors.red),
          ],
        ),
      ),

      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(shape: BoxShape.circle),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFF9ED8EB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Halo, $username ✨',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24527A),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7EC8E3),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDashboardCard(
                        context,
                        'Pengeluaran',
                        Icons.attach_money,
                        const Color(0xFF66BB6A),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const AdvancedExpenseListScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        'Statistik',
                        Icons.pie_chart,
                        const Color(0xFFEF5350),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StatisticsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        'Kategori',
                        Icons.category,
                        const Color(0xFF26A69A),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        'Pengeluaran Bersama',
                        Icons.group,
                        const Color(0xFF5C6BC0),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const SharedExpensesScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        'Konversi Mata Uang',
                        Icons.currency_exchange,
                        const Color(0xFFFFB74D),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CurrencyScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color, [
    VoidCallback? onTap,
  ]) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap:
            onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur $title segera hadir!')),
              );
            },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF24527A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  