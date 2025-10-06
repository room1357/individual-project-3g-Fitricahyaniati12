import 'package:flutter/material.dart';
import '../models/looping_examples.dart';

class LoopingScreen extends StatelessWidget {
  const LoopingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hitung total
    double total1 = LoopingExamples.calculateTotalTraditional(LoopingExamples.expenses);
    double total2 = LoopingExamples.calculateTotalForIn(LoopingExamples.expenses);
    double total3 = LoopingExamples.calculateTotalForEach(LoopingExamples.expenses);
    double total4 = LoopingExamples.calculateTotalFold(LoopingExamples.expenses);
    double total5 = LoopingExamples.calculateTotalReduce(LoopingExamples.expenses);

    // Cari data
    var cari1 = LoopingExamples.findExpenseTraditional(LoopingExamples.expenses, '2');
    var cari2 = LoopingExamples.findExpenseWhere(LoopingExamples.expenses, '3');

    // Filter
    var makanan1 = LoopingExamples.filterByCategoryManual(LoopingExamples.expenses, 'Makanan');
    var makanan2 = LoopingExamples.filterByCategoryWhere(LoopingExamples.expenses, 'Makanan');

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Looping')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("=== Total Pengeluaran ===", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("For loop tradisional: Rp $total1"),
            Text("For-in loop: Rp $total2"),
            Text("forEach: Rp $total3"),
            Text("fold: Rp $total4"),
            Text("reduce: Rp $total5"),

            const SizedBox(height: 20),
            const Text("=== Cari Data ===", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("findExpenseTraditional (id=2): ${cari1?.title ?? 'Tidak ditemukan'}"),
            Text("findExpenseWhere (id=3): ${cari2?.title ?? 'Tidak ditemukan'}"),

            const SizedBox(height: 20),
            const Text("=== Filter Data ===", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Filter Manual (Makanan): ${makanan1.length} item"),
            Text("Filter Where (Makanan): ${makanan2.length} item"),
          ],
        ),
      ),
    );
  }
}
