import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'e3918a76';
  static const String _baseUrl = 'https://api.hgbrasil.com/finance';

  Future<double> fetchExchangeRate(String fromCurrency, String toCurrency) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey');  

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final currencies = data['results']['currencies'];

      double fromRate = fromCurrency == 'BRL' ? 1.0 : currencies[fromCurrency]['buy'];
      double toRate = toCurrency == 'BRL' ? 1.0 : currencies[toCurrency]['buy'];

      return fromRate / toRate;
    } else {
      throw Exception('Erro ao carregar dados de câmbio');
    }
  }
}