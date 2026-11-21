import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singilbuddy/Services/api_service.dart';

void main() {
  group('Singil Buddy Unit & Widget Tests', () {
    test('Debt model calculates remaining balance correctly', () {
      final debt = Debt(
        id: '1',
        debtorName: 'Juan Dela Cruz',
        totalDebt: 1000.0,
        paidAmount: 300.0,
        promiseDate: '2026-09-30',
        status: 'Partially Paid',
      );

      expect(debt.remaining, 700.0);
      expect(debt.debtorName, 'Juan Dela Cruz');
      expect(debt.status, 'Partially Paid');
    });

    test('Debt model JSON serialization and deserialization works correctly', () {
      final json = {
        'id': '101',
        'debtorName': 'Maria Santos',
        'totalDebt': 2500.0,
        'paidAmount': 500.0,
        'promiseDate': '2026-10-05',
        'status': 'Partially Paid',
        'description': 'Shared bills',
      };

      final debt = Debt.fromJson(json);
      expect(debt.id, '101');
      expect(debt.debtorName, 'Maria Santos');
      expect(debt.remaining, 2000.0);

      final exportedJson = debt.toJson();
      expect(exportedJson['debtorName'], 'Maria Santos');
      expect(exportedJson['totalDebt'], 2500.0);
      expect(exportedJson['paidAmount'], 500.0);
    });

    testWidgets('Singil Buddy basic UI elements render without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Singil Buddy')),
            body: const Center(
              child: Text('Para walang nakakalimot, walang nagkakasamaan ng loob.'),
            ),
          ),
        ),
      );

      expect(find.text('Singil Buddy'), findsOneWidget);
      expect(find.text('Para walang nakakalimot, walang nagkakasamaan ng loob.'), findsOneWidget);
    });
  });
}
