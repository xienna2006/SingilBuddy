import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String databaseUrl =
      'https://singilbuddy-default-rtdb.asia-southeast1.firebasedatabase.app';
  static const String apiUrl = '$databaseUrl/debts.json';

  Future<dynamic> getDebts() async {
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
