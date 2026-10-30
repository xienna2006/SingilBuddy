import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model class representing a Debt item in SingilBuddy,
/// matching MockAPI and app functions.
class Debt {
  final String? id;
  final String debtorName;
  final double totalDebt;
  final double paidAmount;
  final String promiseDate;
  final String status;
  final String? description;

  Debt({
    this.id,
    required this.debtorName,
    required this.totalDebt,
    this.paidAmount = 0.0,
    this.promiseDate = '',
    this.status = 'Unpaid',
    this.description,
  });

  double get remaining => totalDebt - paidAmount;

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id']?.toString(),
      debtorName: (json['debtorName'] ?? json['name'] ?? '').toString(),
      totalDebt: (json['totalDebt'] ?? json['total'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? json['paid'] ?? 0).toDouble(),
      promiseDate:
          (json['promiseDate'] ?? json['promisedDate'] ?? json['dueDate'] ?? '')
              .toString(),
      status: (json['status'] ?? 'Unpaid').toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'debtorName': debtorName,
      'totalDebt': totalDebt,
      'paidAmount': paidAmount,
      'promiseDate': promiseDate,
      'status': status,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    return data;
  }
}

class ApiService {
  static const String apiUrl =
      'https://6ab24f065b9b60f39d3487c5.mockapi.io/debts';

  // 1. GET Request: Fetch debts from the API
  Future<List<Debt>> fetchDebts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => Debt.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load debts: ${response.statusCode}');
    }
  }

  // Alias for backward compatibility
  Future<List<Debt>> getDebts() => fetchDebts();

  // 2. POST Request: Create a new debt
  Future<Debt> createDebt(Debt newDebt) async {
    final Map<String, dynamic> jsonData = newDebt.toJson();
    jsonData.remove('id'); // Remove local ID before posting

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Debt.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create debt: ${response.statusCode}');
    }
  }

  // 3. PUT Request: Update an existing debt
  Future<Debt> updateDebt(Debt debt) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${debt.id}'), // Targeted ID endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(debt.toJson()),
    );

    if (response.statusCode == 200) {
      return Debt.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update debt: ${response.statusCode}');
    }
  }

  // 4. DELETE Request: Remove a debt by ID
  Future<void> deleteDebt(dynamic id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'), // Targeted ID endpoint
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete debt: ${response.statusCode}');
    }
  }
}
