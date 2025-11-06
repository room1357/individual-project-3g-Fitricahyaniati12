import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final CurrencyService _service = CurrencyService();
  double? rate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRate();
  }

  Future<void> fetchRate() async {
    final result = await _service.getRate('USD', 'IDR');
    setState(() {
      rate = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Mata Uang')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              rate != null
                  ? '1 USD = ${rate!.toStringAsFixed(2)} IDR'
                  : 'Mengambil data...',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Masukkan jumlah USD',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (rate != null && _controller.text.isNotEmpty) {
                  double usd = double.parse(_controller.text);
                  double idr = usd * rate!;
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text('Hasil Konversi'),
                          content: Text(
                            '$usd USD = ${idr.toStringAsFixed(2)} IDR',
                          ),
                        ),
                  );
                }
              },
              child: const Text('Konversi ke IDR'),
            ),
          ],
        ),
      ),
    );
  }
}
