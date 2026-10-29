import 'package:cloud_firestore/cloud_firestore.dart';

class DebtRecord {
  final String id;
  final String name;
  final double totalDebt;
  final double paidAmount;
  final DateTime? promisedDate;

  DebtRecord({
    required this.id,
    required this.name,
    required this.totalDebt,
    this.paidAmount = 0,
    this.promisedDate,
  });

  double get remaining => totalDebt - paidAmount;

  factory DebtRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return DebtRecord(
      id: document.id,
      name: data['name'] ?? '',
      totalDebt: (data['totalDebt'] ?? 0).toDouble(),
      paidAmount: (data['paidAmount'] ?? 0).toDouble(),
      promisedDate: data['promisedDate'] != null
          ? (data['promisedDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalDebt': totalDebt,
      'paidAmount': paidAmount,
      'promisedDate':
          promisedDate != null ? Timestamp.fromDate(promisedDate!) : null,
    };
  }
}

class PaymentRecord {
  final String id;
  final double amount;
  final DateTime date;

  PaymentRecord({
    required this.id,
    required this.amount,
    required this.date,
  });

  factory PaymentRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return PaymentRecord(
      id: document.id,
      amount: (data['amount'] ?? 0).toDouble(),
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date),
    };
  }
}

class SingilBuddyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get debts =>
      _firestore.collection('debts');

  CollectionReference<Map<String, dynamic>> paymentsFor(String debtId) =>
      debts.doc(debtId).collection('payments');

  Stream<List<DebtRecord>> getDebts() {
    return debts
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DebtRecord.fromFirestore(doc))
              .toList(),
        );
  }

  Future<String> addDebt({
    required String name,
    required double amount,
    DateTime? promisedDate,
  }) async {
    final document = await debts.add({
      'name': name,
      'totalDebt': amount,
      'paidAmount': 0,
      'promisedDate': promisedDate != null
          ? Timestamp.fromDate(promisedDate)
          : null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  Future<void> updatePromiseDate({
    required String debtId,
    required DateTime promisedDate,
  }) async {
    await debts.doc(debtId).update({
      'promisedDate': Timestamp.fromDate(promisedDate),
    });
  }

  Future<void> addPayment({
    required String debtId,
    required double amount,
  }) async {
    final debtReference = debts.doc(debtId);

    await _firestore.runTransaction((transaction) async {
      final debtSnapshot = await transaction.get(debtReference);

      if (!debtSnapshot.exists) {
        throw Exception('Debt record not found.');
      }

      final data = debtSnapshot.data() ?? {};

      final currentPaid =
          (data['paidAmount'] ?? 0).toDouble();

      final totalDebt =
          (data['totalDebt'] ?? 0).toDouble();

      final newPaid = currentPaid + amount;

      if (amount <= 0) {
        throw Exception('Payment must be greater than zero.');
      }

      if (newPaid > totalDebt) {
        throw Exception('Payment cannot exceed the remaining debt.');
      }

      transaction.update(debtReference, {
        'paidAmount': newPaid,
      });
    });

    await paymentsFor(debtId).add({
      'amount': amount,
      'date': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<PaymentRecord>> getPaymentHistory(String debtId) {
    return paymentsFor(debtId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PaymentRecord.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> deleteDebt(String debtId) async {
    final paymentSnapshot = await paymentsFor(debtId).get();

    for (final payment in paymentSnapshot.docs) {
      await payment.reference.delete();
    }

    await debts.doc(debtId).delete();
  }
}