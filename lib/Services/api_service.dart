import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      'https://6ab24f065b9b60f39d3487c5.mockapi.io/debts';

  Future<List<dynamic>> getDebts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load debts: ${response.statusCode}',
      );
    }
  }
}