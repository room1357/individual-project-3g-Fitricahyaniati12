import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/advanced_expense_list_screen.dart';
import 'models/looping_examples.dart';
import 'screens/looping_screen.dart';

void main() {
  double total = LoopingExamples.calculateTotalFold(LoopingExamples.expenses);
  debugPrint('Total pengeluaran: Rp ${total.toStringAsFixed(0)}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      title: 'Expense Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Halaman pertama kali muncul
      initialRoute: '/login',

      // Daftar route (rute)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/expense-list': (context) => const AdvancedExpenseListScreen(),
        '/looping': (context) => const LoopingScreen(),
      },
    );
  }
}
