import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/export_service.dart';
import '../models/expense.dart';
import '../services/expense_manager.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  State<AdvancedExpenseListScreen> createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = ExpenseManager.expenses;
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredExpenses = expenses;
  }

  // ➕ tambah expense
  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
      _filterExpenses();
    });
  }

  // ✏️ update expense
  void _updateExpense(Expense updatedExpense) {
    setState(() {
      final index = expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        expenses[index] = updatedExpense;
      }
      _filterExpenses();
    });
  }

  // ❌ hapus expense
  void _deleteExpense(Expense expense) {
    setState(() {
      expenses.removeWhere((e) => e.id == expense.id);
      _filterExpenses();
    });
  }

  // 📄 EXPORT PDF (simpan file + tampilkan path)
  Future<void> _exportToPDF() async {
    try {
      final exportService = ExportService();
      final file = await exportService.exportToPDF(filteredExpenses);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ PDF berhasil disimpan di:\n${file.path}",
            style: const TextStyle(fontSize: 13),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Gagal export PDF: $e")));
    }
  }

  // 📊 EXPORT CSV (simpan file + tampilkan path)
  Future<void> _exportToCSV() async {
    try {
      final exportService = ExportService();
      final file = await exportService.exportToCSV(filteredExpenses);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ CSV berhasil disimpan di:\n${file.path}",
            style: const TextStyle(fontSize: 13),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Gagal export CSV: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran Advanced'),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pdf') {
                _exportToPDF();
              } else if (value == 'csv') {
                _exportToCSV();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'pdf',
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Export PDF'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'csv',
                    child: Row(
                      children: [
                        Icon(Icons.table_chart, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Export CSV'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // 🏷️ Filter kategori
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children:
                  [
                        'Semua',
                        'Makanan',
                        'Transportasi',
                        'Utilitas',
                        'Hiburan',
                        'Pendidikan',
                      ]
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                                _filterExpenses();
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // 📈 Statistik
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard(
                  'Rata-rata',
                  _calculateAverage(filteredExpenses),
                ),
              ],
            ),
          ),

          // 📋 Daftar pengeluaran
          Expanded(
            child:
                filteredExpenses.isEmpty
                    ? const Center(
                      child: Text('Tidak ada pengeluaran ditemukan'),
                    )
                    : ListView.builder(
                      itemCount: filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(
                                expense.category,
                              ),
                              child: Icon(
                                _getCategoryIcon(expense.category),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(expense.title),
                            subtitle: Text(
                              '${expense.category} • ${expense.formattedDate}\n${expense.description}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditExpenseScreen(
                                              expense: expense,
                                              onUpdateExpense: _updateExpense,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteExpense(expense),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),

      // ➕ Tombol tambah
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(onAddExpense: _addExpense),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // 🔍 Filter pencarian & kategori
  void _filterExpenses() {
    setState(() {
      filteredExpenses =
          expenses.where((expense) {
            final query = searchController.text.toLowerCase();

            final matchesSearch =
                query.isEmpty ||
                expense.title.toLowerCase().contains(query) ||
                expense.description.toLowerCase().contains(query);

            final matchesCategory =
                selectedCategory == 'Semua' ||
                expense.category == selectedCategory;

            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  // 📊 Widget statistik kecil
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // 💰 Hitung total
  String _calculateTotal(List<Expense> expenses) {
    double total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  // 📈 Hitung rata-rata
  String _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 'Rp 0';
    double average =
        expenses.fold(0.0, (sum, expense) => sum + expense.amount) /
        expenses.length;
    return 'Rp ${average.toStringAsFixed(0)}';
  }

  // 🏷️ Ikon kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.restaurant;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Utilitas':
        return Icons.flash_on;
      case 'Hiburan':
        return Icons.movie;
      case 'Pendidikan':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }

  // 🎨 Warna kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.green;
      case 'Transportasi':
        return Colors.blue;
      case 'Utilitas':
        return Colors.orange;
      case 'Hiburan':
        return Colors.purple;
      case 'Pendidikan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
