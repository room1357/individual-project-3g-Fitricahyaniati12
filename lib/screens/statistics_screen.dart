import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../utils/currency_utils.dart';
import '../services/expense_manager.dart';
import '../services/currency_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Expense> _expenses = [];
  final CurrencyService _currencyService = CurrencyService();

  String _selectedCurrency = 'IDR';
  double? _conversionRate;
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

  double get total => _expenses.fold(0, (sum, e) => sum + e.amount);

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

    final totalInSelectedCurrency =
        _conversionRate != null ? total * _conversionRate! : total;

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
      backgroundColor: const Color.fromARGB(255, 255, 212, 227), // 🎨 warna dasar lembut
      appBar: AppBar(
        backgroundColor: const Color(0xFF7EC8E3),
        title: const Text(
          "Statistik Pengeluaran",
          style: TextStyle(
            color: Color(0xFF24527A),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),

      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                //color: Color(0xFF7EC8E3),
                shape: BoxShape.circle,
              ),
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

          // 📊 Konten utama
          _expenses.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada data pengeluaran",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF24527A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 250,
                              child: PieChart(
                                PieChartData(
                                  sections: sections,
                                  centerSpaceRadius: 40,
                                  borderData: FlBorderData(show: false),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Distribusi Pengeluaran per Kategori",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF24527A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 🔹 Dropdown Pilihan Mata Uang
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tampilkan dalam:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF24527A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: _selectedCurrency,
                              dropdownColor: Colors.white,
                              iconEnabledColor: const Color(0xFF24527A),
                              style: const TextStyle(
                                  color: Color(0xFF24527A), fontSize: 16),
                              items: const [
                                DropdownMenuItem(
                                    value: 'IDR', child: Text('IDR (Rupiah)')),
                                DropdownMenuItem(
                                    value: 'USD', child: Text('USD (Dollar)')),
                                DropdownMenuItem(
                                    value: 'EUR', child: Text('EUR (Euro)')),
                              ],
                              onChanged: (value) {
                                if (value != null) _convertCurrency(value);
                              },
                            ),
                            if (_loading)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF7EC8E3),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 💰 Total
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7EC8E3),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "Total: ${CurrencyUtils.formatCurrency(totalInSelectedCurrency)} $_selectedCurrency",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
