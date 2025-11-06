import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../utils/currency_utils.dart';
import '../services/expense_manager.dart';
import '../services/currency_service.dart'; // ✅ Tambahan untuk API konversi

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Expense> _expenses = [];
  final CurrencyService _currencyService = CurrencyService();

  String _selectedCurrency = 'IDR'; // default mata uang
  double? _conversionRate; // nilai konversi dari IDR ke target
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    setState(() {
      _expenses = ExpenseManager.expenses;
    });
  }

  double get total {
    return _expenses.fold(0, (sum, e) => sum + e.amount);
  }

  Future<void> _convertCurrency(String targetCurrency) async {
    if (targetCurrency == 'IDR') {
      setState(() {
        _conversionRate = null;
        _selectedCurrency = 'IDR';
      });
      return;
    }

    setState(() => _loading = true);
    try {
      final rate = await _currencyService.getRate('IDR', targetCurrency);
      setState(() {
        _conversionRate = rate;
        _selectedCurrency = targetCurrency;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal konversi: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = <String, double>{};
    for (var e in _expenses) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0) + e.amount;
    }

    final totalInSelectedCurrency = _conversionRate != null
        ? total * _conversionRate!
        : total;

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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: PieChart(PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                    )),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Dropdown pilihan mata uang
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Tampilkan dalam: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedCurrency,
                        items: const [
                          DropdownMenuItem(
                              value: 'IDR', child: Text('IDR (Rupiah)')),
                          DropdownMenuItem(
                              value: 'USD', child: Text('USD (Dollar)')),
                          DropdownMenuItem(
                              value: 'EUR', child: Text('EUR (Euro)')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _convertCurrency(value);
                          }
                        },
                      ),
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Tampilkan total sesuai mata uang yang dipilih
                  Text(
                    "Total: ${CurrencyUtils.formatCurrency(totalInSelectedCurrency)} $_selectedCurrency",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
