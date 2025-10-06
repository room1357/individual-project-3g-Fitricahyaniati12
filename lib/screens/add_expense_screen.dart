import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAddExpense; // callback untuk kirim data ke list utama

  const AddExpenseScreen({super.key, required this.onAddExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  void _submitForm() {
    if (!_formKey.currentState!.validate() || _selectedDate == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua field termasuk tanggal & kategori!")),
      );
      return;
    }

    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      category: _selectedCategory!,
      date: _selectedDate!,
      description: _descriptionController.text,
    );

    widget.onAddExpense(newExpense); // kirim ke parent
    Navigator.pop(context); // kembali
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = Category.defaultCategories.map((c) => c.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Judul
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Judul Pengeluaran"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Judul tidak boleh kosong" : null,
                ),
                const SizedBox(height: 12),

                // Jumlah
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
                  validator: (value) =>
                      value == null || double.tryParse(value) == null ? "Masukkan angka yang valid" : null,
                ),
                const SizedBox(height: 12),

                // Dropdown Kategori
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: "Kategori"),
                  items: categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? "Pilih kategori" : null,
                ),
                const SizedBox(height: 12),

                // Date Picker
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "Belum pilih tanggal"
                            : "Tanggal: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Deskripsi
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
