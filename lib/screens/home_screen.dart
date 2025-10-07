import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'advanced_expense_list_screen.dart'; // ganti ke advanced
import 'profile_screen.dart';
import 'statistics_screen.dart'; // ✅ tambahkan import ini

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              // Logout dengan pushAndRemoveUntil
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // Card Pengeluaran
                  _buildDashboardCard(
                    context,
                    'Pengeluaran',
                    Icons.attach_money,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdvancedExpenseListScreen(),
                        ),
                      );
                    },
                  ),

                  // Card Profil
                  _buildDashboardCard(
                    context,
                    'Profil',
                    Icons.person,
                    Colors.blue,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),

                  // ✅ Card Statistik
                  _buildDashboardCard(
                    context,
                    'Statistik',
                    Icons.pie_chart,
                    Colors.red,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatisticsScreen(),
                        ),
                      );
                    },
                  ),

                  // Card Pesan
                  _buildDashboardCard(
                    context,
                    'Pesan',
                    Icons.message,
                    Colors.orange,
                    null,
                  ),

                  // Card Pengaturan
                  _buildDashboardCard(
                    context,
                    'Pengaturan',
                    Icons.settings,
                    Colors.purple,
                    null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap ??
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
