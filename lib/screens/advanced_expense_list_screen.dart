import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

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

class _AdvancedExpenseListScreenState
    extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = ExpenseManager.expenses;
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredExpenses = expenses;
  }

  // ➕ fungsi untuk menambah expense baru
  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
      _filterExpenses();
    });
  }

  // ✏️ fungsi untuk update expense
  void _updateExpense(Expense updatedExpense) {
    setState(() {
      final index = expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        expenses[index] = updatedExpense;
      }
      _filterExpenses();
    });
  }

  // ❌ fungsi untuk hapus expense
  void _deleteExpense(Expense expense) {
    setState(() {
      expenses.removeWhere((e) => e.id == expense.id);
      _filterExpenses();
    });
  }

  /// 📊 Export ke CSV
  Future<void> _exportToCSV() async {
    final StringBuffer csv = StringBuffer();
    csv.writeln("Judul,Kategori,Tanggal,Jumlah,Deskripsi");

    for (var e in filteredExpenses) {
      csv.writeln(
          "${e.title},${e.category},${e.formattedDate},${e.amount},${e.description}");
    }

    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/pengeluaran.csv";
    final file = File(path);
    await file.writeAsString(csv.toString());

    await Share.shareXFiles([XFile(file.path)], text: "Laporan Pengeluaran (CSV)");
  }

  /// 📄 Export ke PDF
  Future<void> _exportToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Laporan Pengeluaran",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...filteredExpenses.map((e) => pw.Text(
                  "${e.title} - Rp ${e.amount} (${e.category}, ${e.formattedDate})")),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/pengeluaran.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: "Laporan Pengeluaran (PDF)");
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
            itemBuilder: (context) => [
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
          // Search bar
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

          // Category filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                'Semua',
                'Makanan',
                'Transportasi',
                'Utilitas',
                'Hiburan',
                'Pendidikan'
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

          // Statistics summary
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard('Rata-rata', _calculateAverage(filteredExpenses)),
              ],
            ),
          ),

          // Expense list
          Expanded(
            child: filteredExpenses.isEmpty
                ? const Center(child: Text('Tidak ada pengeluaran ditemukan'))
                : ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(expense.category),
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
                              // Tombol edit
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditExpenseScreen(
                                        expense: expense,
                                        onUpdateExpense: _updateExpense,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Tombol hapus
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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

      // ➕ tombol tambah pengeluaran
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

  void _filterExpenses() {
    setState(() {
      filteredExpenses = expenses.where((expense) {
        final query = searchController.text.toLowerCase();

        final matchesSearch = query.isEmpty ||
            expense.title.toLowerCase().contains(query) ||
            expense.description.toLowerCase().contains(query);

        final matchesCategory =
            selectedCategory == 'Semua' || expense.category == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

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

  String _calculateTotal(List<Expense> expenses) {
    double total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  String _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 'Rp 0';
    double average =
        expenses.fold(0.0, (sum, expense) => sum + expense.amount) /
            expenses.length;
    return 'Rp ${average.toStringAsFixed(0)}';
  }

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
