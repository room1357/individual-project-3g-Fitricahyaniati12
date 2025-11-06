import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  Future<double> getRate(String from, String to) async {
    final url = Uri.parse(
        'https://api.exchangerate-api.com/v4/latest/$from');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rates'][to] * 1.0;
    } else {
      throw Exception('Failed to fetch rate');
    }
  }
}
