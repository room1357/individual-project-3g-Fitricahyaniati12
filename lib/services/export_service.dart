import 'dart:io';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';
import '../utils/date_utils.dart';
import '../utils/currency_utils.dart';

class ExportService {
  Future<File> exportToCSV(List<Expense> expenses) async {
    final rows = [
      ["ID", "Judul", "Kategori", "Jumlah", "Tanggal"],
      ...expenses.map((e) => [
            e.id,
            e.title,
            e.category,
            e.amount.toString(),
            DateUtilsHelper.formatDate(e.date),
          ])
    ];

    String csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/expenses.csv");
    await file.writeAsString(csv);
    return file;
  }

  Future<File> exportToPDF(List<Expense> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Table.fromTextArray(
          headers: ["Judul", "Kategori", "Jumlah", "Tanggal"],
          data: expenses.map((e) {
            return [
              e.title,
              e.category,
              CurrencyUtils.formatCurrency(e.amount),
              DateUtilsHelper.formatDate(e.date),
            ];
          }).toList(),
        ),
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/expenses.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
