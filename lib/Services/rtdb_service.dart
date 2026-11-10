import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class RealtimeDatabaseService {
  static final RealtimeDatabaseService _instance =
      RealtimeDatabaseService._internal();
  factory RealtimeDatabaseService() => _instance;
  RealtimeDatabaseService._internal();

  static const String databaseUrl =
      'https://singilbuddy-default-rtdb.asia-southeast1.firebasedatabase.app';

  late final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: databaseUrl,
  );

  DatabaseReference get debtsRef => _db.ref('debts');
  DatabaseReference get paidPeopleRef => _db.ref('paidPeople');
  DatabaseReference get recentPaymentsRef => _db.ref('recentPayments');

  static bool _isSeeding = false;

  /// Seed initial debts, paid people, and recent payments to Firebase if empty
  Future<void> seedIfEmpty(
    List<Map<String, dynamic>> initialDebts,
    List<Map<String, dynamic>> initialPaid,
  ) async {
    if (_isSeeding) return;
    _isSeeding = true;
    try {
      final debtsSnap = await debtsRef.get();
      final paidSnap = await paidPeopleRef.get();
      final paymentsSnap = await recentPaymentsRef.get();

      final bool debtsEmpty = !debtsSnap.exists || debtsSnap.value == null;
      final bool paidEmpty = !paidSnap.exists || paidSnap.value == null;
      final bool paymentsEmpty = !paymentsSnap.exists || paymentsSnap.value == null;

      if (debtsEmpty && paidEmpty) {
        for (final debt in initialDebts) {
          final newRef = debtsRef.push();
          final data = Map<String, dynamic>.from(debt);
          data['id'] = newRef.key;
          await newRef.set(data);
          debt['id'] = newRef.key;
        }

        for (final paid in initialPaid) {
          final newRef = paidPeopleRef.push();
          final data = Map<String, dynamic>.from(paid);
          data['id'] = newRef.key;
          await newRef.set(data);
          paid['id'] = newRef.key;
        }
        debugPrint('RealtimeDatabase: Initial sample data seeded to Firebase.');
      }

      // Seed recentPayments ONLY if completely empty in Firebase
      if (paymentsEmpty) {
        final Map<String, Map<String, dynamic>> uniquePayments = {};

        void extractPayment(dynamic record) {
          if (record is Map && record['payments'] != null) {
            final debtorName = record['name']?.toString() ?? '';
            final debtorId = record['id']?.toString() ?? '';
            final pList = record['payments'];

            void addP(dynamic p) {
              if (p is Map) {
                final amt = (p['amount'] as num?)?.toDouble() ?? 0.0;
                final dt = (p['date'] ?? '').toString();
                final key =
                    '${debtorName.toLowerCase().trim()}|${amt.toStringAsFixed(2)}|${dt.toLowerCase().trim()}';
                if (key != '||0.00|' && !uniquePayments.containsKey(key)) {
                  uniquePayments[key] = {
                    'debtId': debtorId,
                    'name': debtorName,
                    'amount': amt,
                    'date': dt,
                    'timestamp': p['timestamp'] ??
                        DateTime.now().millisecondsSinceEpoch,
                  };
                }
              }
            }

            if (pList is List) {
              for (final p in pList) {
                addP(p);
              }
            } else if (pList is Map) {
              pList.forEach((_, p) => addP(p));
            }
          }
        }

        if (debtsSnap.exists && debtsSnap.value != null) {
          final v = debtsSnap.value;
          if (v is Map) {
            v.values.forEach(extractPayment);
          } else if (v is List) {
            v.forEach(extractPayment);
          }
        }
        if (paidSnap.exists && paidSnap.value != null) {
          final v = paidSnap.value;
          if (v is Map) {
            v.values.forEach(extractPayment);
          } else if (v is List) {
            v.forEach(extractPayment);
          }
        }

        // If no payments were in existing DB, extract from initial local sample lists
        if (uniquePayments.isEmpty) {
          for (final debt in initialDebts) {
            extractPayment(debt);
          }
          for (final paid in initialPaid) {
            extractPayment(paid);
          }
        }

        for (final payment in uniquePayments.values) {
          final newRef = recentPaymentsRef.push();
          final data = Map<String, dynamic>.from(payment);
          data['id'] = newRef.key;
          await newRef.set(data);
        }

        if (uniquePayments.isNotEmpty) {
          debugPrint(
            'RealtimeDatabase: Seeded ${uniquePayments.length} unique payments to recentPayments in Firebase.',
          );
        }
      }
    } catch (e) {
      debugPrint('RealtimeDatabase seed error: $e');
    } finally {
      _isSeeding = false;
    }
  }

  /// Automatically clean up any existing duplicate entries in Firebase RTDB
  Future<void> cleanupDuplicates() async {
    try {
      // 1. Deduplicate paidPeople in Firebase
      final paidSnapshot = await paidPeopleRef.get();
      if (paidSnapshot.value is Map) {
        final Map<String, String> seenPaid = {};
        final List<String> toRemove = [];
        (paidSnapshot.value as Map).forEach((k, v) {
          if (v is Map && v['name'] != null) {
            final name = v['name'].toString().toLowerCase().trim();
            if (name.isNotEmpty) {
              if (seenPaid.containsKey(name)) { 
                toRemove.add(k.toString());
              } else {
                seenPaid[name] = k.toString();
              }
            }
          }
        });
        for (final k in toRemove) {
          await paidPeopleRef.child(k).remove();
        }
        if (toRemove.isNotEmpty) {
          debugPrint('RealtimeDatabase: Cleaned ${toRemove.length} duplicate paidPeople from Firebase.');
        }
      }

      // 2. Deduplicate debts in Firebase
      final debtsSnapshot = await debtsRef.get();
      if (debtsSnapshot.value is Map) {
        final Map<String, String> seenDebts = {};
        final List<String> toRemove = [];
        (debtsSnapshot.value as Map).forEach((k, v) {
          if (v is Map && v['name'] != null) {
            final name = v['name'].toString().toLowerCase().trim();
            if (name.isNotEmpty) {
              if (seenDebts.containsKey(name)) {
                toRemove.add(k.toString());
              } else {
                seenDebts[name] = k.toString();
              }
            }
          }
        });
        for (final k in toRemove) {
          await debtsRef.child(k).remove();
        }
        if (toRemove.isNotEmpty) {
          debugPrint('RealtimeDatabase: Cleaned ${toRemove.length} duplicate debts from Firebase.');
        }
      }

      // 3. Deduplicate recentPayments in Firebase
      final paymentsSnapshot = await recentPaymentsRef.get();
      final pVal = paymentsSnapshot.value;
      if (pVal != null) {
        final Map<String, String> seenPayments = {};
        final List<String> toRemove = [];

        void checkPayment(String key, dynamic v) {
          if (v is Map) {
            final name = (v['name'] ?? '').toString().toLowerCase().trim();
            final amount =
                ((v['amount'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);
            final date = (v['date'] ?? '').toString().toLowerCase().trim();
            final uniqueKey = '$name|$amount|$date';
            if (uniqueKey != '||0.00|') {
              if (seenPayments.containsKey(uniqueKey)) {
                toRemove.add(key);
              } else {
                seenPayments[uniqueKey] = key;
              }
            }
          }
        }

        if (pVal is Map) {
          pVal.forEach((k, v) => checkPayment(k.toString(), v));
        } else if (pVal is List) {
          for (int i = 0; i < pVal.length; i++) {
            if (pVal[i] != null) {
              checkPayment(i.toString(), pVal[i]);
            }
          }
        }

        for (final k in toRemove) {
          await recentPaymentsRef.child(k).remove();
        }
        if (toRemove.isNotEmpty) {
          debugPrint(
            'RealtimeDatabase: Cleaned ${toRemove.length} duplicate payments from Firebase.',
          );
        }
      }
    } catch (e) {
      debugPrint('RealtimeDatabase cleanupDuplicates error: $e');
    }
  }

  /// Stream of active debts from Firebase (deduplicated by debtor name)
  Stream<List<Map<String, dynamic>>> get debtsStream {
    return debtsRef.onValue.map((event) {
      if (event.snapshot.value == null) return <Map<String, dynamic>>[];
      final rawList = _parseList(event.snapshot);
      final Map<String, Map<String, dynamic>> unique = {};
      for (final item in rawList) {
        final key = (item['name']?.toString().toLowerCase().trim() ?? '');
        if (key.isNotEmpty) {
          unique[key] = item;
        } else if (item['id'] != null) {
          unique[item['id'].toString()] = item;
        }
      }
      return unique.values.toList();
    });
  }

  /// Stream of paid people records from Firebase (deduplicated by debtor name)
  Stream<List<Map<String, dynamic>>> get paidPeopleStream {
    return paidPeopleRef.onValue.map((event) {
      if (event.snapshot.value == null) return <Map<String, dynamic>>[];
      final rawList = _parseList(event.snapshot);
      final Map<String, Map<String, dynamic>> unique = {};
      for (final item in rawList) {
        final key = (item['name']?.toString().toLowerCase().trim() ?? '');
        if (key.isNotEmpty) {
          unique[key] = item;
        } else if (item['id'] != null) {
          unique[item['id'].toString()] = item;
        }
      }
      return unique.values.toList();
    });
  }

  /// Stream of recent payments from Firebase (deduplicated and sorted newest first)
  Stream<List<Map<String, dynamic>>> get recentPaymentsStream {
    return recentPaymentsRef.onValue.map((event) {
      if (event.snapshot.value == null) return <Map<String, dynamic>>[];
      final rawList = _parsePaymentList(event.snapshot);
      final Map<String, Map<String, dynamic>> unique = {};
      for (final item in rawList) {
        final name = (item['name'] ?? '').toString().toLowerCase().trim();
        final amount =
            ((item['amount'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);
        final date = (item['date'] ?? '').toString().toLowerCase().trim();
        final key = (name.isNotEmpty && date.isNotEmpty)
            ? '$name|$amount|$date'
            : (item['id']?.toString() ?? '');
        if (key.isNotEmpty) {
          unique[key] = item;
        }
      }
      final list = unique.values.toList();
      list.sort((a, b) {
        final int tA = (a['timestamp'] as num?)?.toInt() ?? 0;
        final int tB = (b['timestamp'] as num?)?.toInt() ?? 0;
        if (tA != 0 && tB != 0) {
          return tB.compareTo(tA);
        }
        return (b['date']?.toString() ?? '')
            .compareTo(a['date']?.toString() ?? '');
      });
      return list;
    });
  }

  List<Map<String, dynamic>> _parsePaymentList(DataSnapshot snapshot) {
    final List<Map<String, dynamic>> list = [];
    final value = snapshot.value;

    if (value is Map) {
      value.forEach((key, val) {
        if (val is Map) {
          final item = Map<String, dynamic>.from(val);
          item['id'] = key.toString();
          item['amount'] = (item['amount'] as num?)?.toDouble() ?? 0.0;
          list.add(item);
        }
      });
    } else if (value is List) {
      for (int i = 0; i < value.length; i++) {
        final val = value[i];
        if (val is Map) {
          final item = Map<String, dynamic>.from(val);
          item['id'] = i.toString();
          item['amount'] = (item['amount'] as num?)?.toDouble() ?? 0.0;
          list.add(item);
        }
      }
    }

    return list;
  }

  List<Map<String, dynamic>> _parseList(DataSnapshot snapshot) {
    final List<Map<String, dynamic>> list = [];
    final value = snapshot.value;

    if (value is Map) {
      value.forEach((key, val) {
        if (val is Map) {
          final item = Map<String, dynamic>.from(val);
          item['id'] = key.toString();
          item['total'] = (item['total'] as num?)?.toDouble() ?? 0.0;
          item['paid'] = (item['paid'] as num?)?.toDouble() ?? 0.0;

          if (item['payments'] is List) {
            item['payments'] = (item['payments'] as List)
                .where((p) => p != null)
                .map((p) => Map<String, dynamic>.from(p as Map))
                .toList();
          } else if (item['payments'] is Map) {
            item['payments'] = (item['payments'] as Map)
                .values
                .where((p) => p != null)
                .map((p) => Map<String, dynamic>.from(p as Map))
                .toList();
          } else {
            item['payments'] = <Map<String, dynamic>>[];
          }

          list.add(item);
        }
      });
    } else if (value is List) {
      for (int i = 0; i < value.length; i++) {
        final val = value[i];
        if (val is Map) {
          final item = Map<String, dynamic>.from(val);
          item['id'] = i.toString();
          item['total'] = (item['total'] as num?)?.toDouble() ?? 0.0;
          item['paid'] = (item['paid'] as num?)?.toDouble() ?? 0.0;

          if (item['payments'] is List) {
            item['payments'] = (item['payments'] as List)
                .where((p) => p != null)
                .map((p) => Map<String, dynamic>.from(p as Map))
                .toList();
          } else if (item['payments'] is Map) {
            item['payments'] = (item['payments'] as Map)
                .values
                .where((p) => p != null)
                .map((p) => Map<String, dynamic>.from(p as Map))
                .toList();
          } else {
            item['payments'] = <Map<String, dynamic>>[];
          }

          list.add(item);
        }
      }
    }

    return list;
  }

  /// Save or update an active debt in Firebase
  Future<String> saveDebt(Map<String, dynamic> debt) async {
    try {
      final name = debt['name']?.toString().toLowerCase().trim() ?? '';
      String id = (debt['id'] != null && debt['id'].toString().isNotEmpty)
          ? debt['id'].toString()
          : '';

      // If id is empty, check if debtor with this name already exists in debtsRef
      if (id.isEmpty && name.isNotEmpty) {
        final snapshot = await debtsRef.get();
        if (snapshot.value is Map) {
          (snapshot.value as Map).forEach((k, v) {
            if (v is Map &&
                v['name']?.toString().toLowerCase().trim() == name) {
              id = k.toString();
            }
          });
        }
      }

      if (id.isEmpty) {
        id = debtsRef.push().key!;
      }

      debt['id'] = id;
      await debtsRef.child(id).set(Map<String, dynamic>.from(debt));
      return id;
    } catch (e) {
      debugPrint('RealtimeDatabase saveDebt error: $e');
      return debt['id']?.toString() ?? '';
    }
  }

  /// Remove a debt from active debts in Firebase
  Future<void> deleteDebt(Map<String, dynamic> debt) async {
    try {
      final id = debt['id']?.toString();
      final name = debt['name']?.toString().toLowerCase().trim();

      if (id != null && id.isNotEmpty) {
        await debtsRef.child(id).remove();
      }
      if (name != null && name.isNotEmpty) {
        final snapshot = await debtsRef.get();
        if (snapshot.value is Map) {
          (snapshot.value as Map).forEach((k, v) {
            if (v is Map &&
                v['name']?.toString().toLowerCase().trim() == name) {
              debtsRef.child(k.toString()).remove();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('RealtimeDatabase deleteDebt error: $e');
    }
  }

  /// Move a debt to the paidPeople collection in Firebase without creating duplicates
  Future<void> archivePaidPerson(Map<String, dynamic> debt) async {
    try {
      await deleteDebt(debt);
      final name = debt['name']?.toString().toLowerCase().trim() ?? '';
      String targetId = '';

      final snapshot = await paidPeopleRef.get();
      if (snapshot.value is Map) {
        (snapshot.value as Map).forEach((k, v) {
          if (v is Map &&
              v['name']?.toString().toLowerCase().trim() == name) {
            targetId = k.toString();
          }
        });
      }

      if (targetId.isEmpty) {
        targetId = (debt['id'] != null && debt['id'].toString().isNotEmpty)
            ? debt['id'].toString()
            : paidPeopleRef.push().key!;
      }

      debt['id'] = targetId;
      debt['status'] = 'Paid';
      await paidPeopleRef.child(targetId).set(Map<String, dynamic>.from(debt));
    } catch (e) {
      debugPrint('RealtimeDatabase archivePaidPerson error: $e');
    }
  }

  /// Delete a record from paidPeople in Firebase
  Future<void> deletePaidPerson(Map<String, dynamic> person) async {
    try {
      final id = person['id']?.toString();
      final name = person['name']?.toString().toLowerCase().trim();

      if (id != null && id.isNotEmpty) {
        await paidPeopleRef.child(id).remove();
      }
      if (name != null && name.isNotEmpty) {
        final snapshot = await paidPeopleRef.get();
        if (snapshot.value is Map) {
          (snapshot.value as Map).forEach((k, v) {
            if (v is Map &&
                v['name']?.toString().toLowerCase().trim() == name) {
              paidPeopleRef.child(k.toString()).remove();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('RealtimeDatabase deletePaidPerson error: $e');
    }
  }

  /// Reactivate a paid person back into active debts
  Future<void> reactivatePaidPerson(
    Map<String, dynamic> person,
    Map<String, dynamic> activeDebt,
  ) async {
    try {
      await deletePaidPerson(person);
      await saveDebt(activeDebt);
    } catch (e) {
      debugPrint('RealtimeDatabase reactivatePaidPerson error: $e');
    }
  }

  /// Record and save a payment into recentPayments in Firebase
  Future<String> saveRecentPayment(Map<String, dynamic> payment) async {
    try {
      final name = (payment['name'] ?? '').toString().toLowerCase().trim();
      final amount =
          ((payment['amount'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);
      final date = (payment['date'] ?? '').toString().toLowerCase().trim();

      // Guard against accidental rapid duplicate writes
      final snapshot = await recentPaymentsRef.limitToLast(10).get();
      if (snapshot.value is Map) {
        bool alreadySaved = false;
        (snapshot.value as Map).forEach((k, v) {
          if (v is Map) {
            final vName = (v['name'] ?? '').toString().toLowerCase().trim();
            final vAmount =
                ((v['amount'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);
            final vDate = (v['date'] ?? '').toString().toLowerCase().trim();
            final vTimestamp = (v['timestamp'] as num?)?.toInt() ?? 0;
            final now = DateTime.now().millisecondsSinceEpoch;
            if (vName == name &&
                vAmount == amount &&
                vDate == date &&
                (now - vTimestamp).abs() < 5000) {
              alreadySaved = true;
            }
          }
        });
        if (alreadySaved) {
          debugPrint('RealtimeDatabase: Ignored duplicate rapid payment.');
          return '';
        }
      }

      final newRef = recentPaymentsRef.push();
      final data = Map<String, dynamic>.from(payment);
      data['id'] = newRef.key;
      data['amount'] = (data['amount'] as num?)?.toDouble() ?? 0.0;
      data['timestamp'] ??= DateTime.now().millisecondsSinceEpoch;
      await newRef.set(data);
      debugPrint('RealtimeDatabase: Payment recorded with ID ${newRef.key}');
      return newRef.key!;
    } catch (e) {
      debugPrint('RealtimeDatabase saveRecentPayment error: $e');
      return '';
    }
  }

  /// Delete a payment record from recentPayments in Firebase
  Future<void> deleteRecentPayment(String paymentId) async {
    try {
      if (paymentId.isNotEmpty) {
        await recentPaymentsRef.child(paymentId).remove();
        debugPrint('RealtimeDatabase: Deleted payment $paymentId');
      }
    } catch (e) {
      debugPrint('RealtimeDatabase deleteRecentPayment error: $e');
    }
  }
}
