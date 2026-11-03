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

  /// Seed initial debts to Firebase if the database is currently empty
  Future<void> seedIfEmpty(
    List<Map<String, dynamic>> initialDebts,
    List<Map<String, dynamic>> initialPaid,
  ) async {
    try {
      final debtsSnap = await debtsRef.get();
      final paidSnap = await paidPeopleRef.get();

      final bool debtsEmpty = !debtsSnap.exists || debtsSnap.value == null;
      final bool paidEmpty = !paidSnap.exists || paidSnap.value == null;

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
    } catch (e) {
      debugPrint('RealtimeDatabase seed error: $e');
    }
  }
  
  /// Automatically clean up any existing duplicate entries in Firebase RTDB based on debtor name
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
}
