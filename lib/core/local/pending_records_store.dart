import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PendingRecordsStore {
  static const String _storageKey = 'pending_control_records';

  Future<void> savePendingRecord(
    Map<String, dynamic> payload,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await getPendingRecords();

    final pendingRecord = {
      'localId': DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': DateTime.now().toIso8601String(),
      'endpoint': '/control/registros',
      'status': 'pending',
      'payload': payload,
    };

    records.add(pendingRecord);

    final encoded = jsonEncode(records);

    await prefs.setString(_storageKey, encoded);
  }

  Future<List<Map<String, dynamic>>> getPendingRecords() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_storageKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(data);

    return List<Map<String, dynamic>>.from(decoded);
  }

  Future<int> countPendingRecords() async {
    final records = await getPendingRecords();

    return records.length;
  }

  Future<void> removePendingRecord(String localId) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await getPendingRecords();

    records.removeWhere(
      (item) => item['localId'] == localId,
    );

    final encoded = jsonEncode(records);

    await prefs.setString(_storageKey, encoded);
  }
}