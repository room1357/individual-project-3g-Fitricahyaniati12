import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final CurrencyService _service = CurrencyService();

  final TextEditingController _controller = TextEditingController();

  String fromCurrency = 'USD';
  String toCurrency = 'IDR';
  double? rate;
  String? resultText;

  @override
  void initState() {
    super.initState();
    fetchRate();
  }

  Future<void> fetchRate() async {
    final result = await _service.getRate(fromCurrency, toCurrency);
    setState(() {
      rate = result;
    });
  }

  void convert() {
    if (rate == null || _controller.text.isEmpty) return;

    double input = double.tryParse(_controller.text) ?? 0;
    double converted = input * rate!;
    setState(() {
      resultText =
          '$input $fromCurrency = ${converted.toStringAsFixed(2)} $toCurrency';
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
            // Dropdown Pilihan Mata Uang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: fromCurrency,
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'IDR', child: Text('IDR')),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      fromCurrency = value!;
                    });
                    await fetchRate();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.swap_horiz),
                ),
                DropdownButton<String>(
                  value: toCurrency,
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'IDR', child: Text('IDR')),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      toCurrency = value!;
                    });
                    await fetchRate();
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              rate != null
                  ? '1 $fromCurrency = ${rate!.toStringAsFixed(2)} $toCurrency'
                  : 'Mengambil data...',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan jumlah $fromCurrency',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: convert,
              child: Text('Konversi ke $toCurrency'),
            ),

            const SizedBox(height: 30),
            if (resultText != null)
              Text(
                resultText!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
