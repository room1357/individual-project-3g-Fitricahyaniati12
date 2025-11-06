import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  Future<double?> getRate(String base, String target) async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.exchangerate.host/latest?base=$base&symbols=$target',
        ),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['rates'][target] * 1.0;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
