import 'dart:convert';
import 'package:http/http.dart' as http;

class EnderecoViaCep {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade; 
  final String uf;
  final bool erro;

  EnderecoViaCep({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.erro = false,
  });

  factory EnderecoViaCep.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('erro') && json['erro'] == true) {
      return EnderecoViaCep(
        cep: '',
        logradouro: '',
        complemento: '',
        bairro: '',
        localidade: '',
        uf: '',
        erro: true,
      );
    }
    return EnderecoViaCep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Rua': logradouro,
      'Bairro': bairro,
      'Cidade': localidade,
      'Estado': uf,
      'Complemento': complemento,
    };
  }
}

class ViaCepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';

  Future<EnderecoViaCep?> fetchCep(String cep) async {
    final String cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanCep.length != 8) {
      return null;
    }

    final url = Uri.parse('$_baseUrl/$cleanCep/json/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return EnderecoViaCep.fromJson(data);
      } else {
        throw Exception('Erro ao buscar CEP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na conexão ou ao processar a resposta do ViaCEP: $e');
    }
  }
}
