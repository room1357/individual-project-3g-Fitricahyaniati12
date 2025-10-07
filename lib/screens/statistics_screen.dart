import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../utils/currency_utils.dart';
import '../services/expense_manager.dart'; 

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    // ambil langsung dari ExpenseManager
    setState(() {
      _expenses = ExpenseManager.expenses;
    });
  }

  double get total {
    return _expenses.fold(0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = <String, double>{};
    for (var e in _expenses) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0) + e.amount;
    }

    final sections = categoryTotals.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        title: "${entry.key}\n${percentage.toStringAsFixed(1)}%",
        value: entry.value,
        color: Colors.primaries[
            categoryTotals.keys.toList().indexOf(entry.key) %
                Colors.primaries.length],
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Statistik Pengeluaran")),
      body: _expenses.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: PieChart(PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                  )),
                ),
                const SizedBox(height: 20),
                Text(
                  "Total: ${CurrencyUtils.formatCurrency(total)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }
}
