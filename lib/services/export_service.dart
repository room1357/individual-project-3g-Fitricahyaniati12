import 'dart:io';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';
import '../utils/date_utils.dart';
import '../utils/currency_utils.dart';

class ExportService {
  /// 📊 EXPORT TO CSV
  Future<File> exportToCSV(List<Expense> expenses) async {
    if (expenses.isEmpty) throw Exception("Data pengeluaran kosong");

    final rows = [
      ["Judul", "Kategori", "Jumlah", "Tanggal"],
      ...expenses.map((e) => [
            e.title,
            e.category,
            CurrencyUtils.formatCurrency(e.amount),
            DateUtilsHelper.formatDate(e.date),
          ])
    ];

    final csv = const ListToCsvConverter().convert(rows);

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Pengeluaran.csv");
    await file.writeAsString(csv);

    return file;
  }

  /// 📄 EXPORT TO PDF (format tabel rapi)
  Future<File> exportToPDF(List<Expense> expenses) async {
    if (expenses.isEmpty) throw Exception("Data pengeluaran kosong");

    final pdf = pw.Document();
    double total = expenses.fold(0, (sum, e) => sum + e.amount);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "LAPORAN PENGELUARAN",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              "Tanggal Cetak: ${DateUtilsHelper.formatDate(DateTime.now())}",
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.blueGrey800),
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

          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "Total: ${CurrencyUtils.formatCurrency(total)}",
              style: pw.TextStyle(
                  fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Pengeluaran.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
