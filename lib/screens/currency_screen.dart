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
      backgroundColor: const Color.fromARGB(255, 255, 212, 227),
      appBar: AppBar(
        title: const Text(
          'Konversi Mata Uang',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF7EC8E3),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Dekorasi lingkaran seperti di LoginScreen
          Positioned(
            top: 50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
               // color: Color(0xFF7EC8E3),
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

          // Konten utama
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.currency_exchange,
                    size: 100,
                    color: Color(0xFF24527A),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Konversi Mata Uang",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF24527A),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Dropdown pilihan mata uang
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
                        child: Icon(Icons.swap_horiz, color: Color(0xFF24527A)),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF24527A),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Input jumlah uang
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Masukkan jumlah $fromCurrency',
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: Color(0xFF24527A),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tombol konversi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: convert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7EC8E3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Konversi ke $toCurrency',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Hasil konversi
                  if (resultText != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        resultText!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
