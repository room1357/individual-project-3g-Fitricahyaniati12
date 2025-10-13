import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedExpensesScreen extends StatefulWidget {
  const SharedExpensesScreen({super.key});

  @override
  State<SharedExpensesScreen> createState() => _SharedExpensesScreenState();
}

class _SharedExpensesScreenState extends State<SharedExpensesScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();

  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('shared_expenses');
    if (data != null) {
      setState(() {
        expenses = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shared_expenses', json.encode(expenses));
  }

  void _addExpense() {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();
    final peopleText = peopleController.text.trim();

    if (title.isEmpty || amountText.isEmpty || peopleText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi semua field terlebih dahulu")),
      );
      return;
    }

    final double? totalAmount = double.tryParse(amountText);
    final int? peopleCount = int.tryParse(peopleText);

    if (totalAmount == null || peopleCount == null || peopleCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan angka yang valid")),
      );
      return;
    }

    final double perPerson = totalAmount / peopleCount;

    final newExpense = {
      "title": title,
      "total": totalAmount,
      "people": peopleCount,
      "share": perPerson.toStringAsFixed(2),
    };

    setState(() {
      expenses.add(newExpense);
    });

    _saveExpenses();

    titleController.clear();
    amountController.clear();
    peopleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Expenses"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Nama Pengeluaran",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total Pengeluaran (Rp)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: peopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah Orang yang Berbagi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Tambah Pengeluaran"),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: expenses.isEmpty
                  ? const Center(child: Text("Belum ada pengeluaran."))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Card(
                          child: ListTile(
                            title: Text(expense["title"]),
                            subtitle: Text(
                              "Total: Rp${expense["total"]}  \nOrang: ${expense["people"]}\nPer Orang: Rp${expense["share"]}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  expenses.removeAt(index);
                                });
                                _saveExpenses();
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
