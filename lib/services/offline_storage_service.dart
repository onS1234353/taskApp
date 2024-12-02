import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OfflineQueueService {
  static const _offlineQueueKey = 'offline_todo_queue';

  // Queue operations for todos that couldn't be synced
  static Future<void> queueTodoOperation(Map<String, dynamic> operation) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = await getOfflineQueue();
    queue.add(operation);
    await prefs.setStringList(
        _offlineQueueKey, queue.map((op) => json.encode(op)).toList());
  }

  static Future<List<Map<String, dynamic>>> getOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getStringList(_offlineQueueKey) ?? [];
    return queueJson
        .map((jsonStr) => json.decode(jsonStr) as Map<String, dynamic>)
        .toList();
  }

  static Future<void> clearOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_offlineQueueKey);
  }
}

class OfflineStorageService {
  static const _dataKey = 'offline_data';
  static const _syncTimestampKey = 'last_sync_timestamp';

  // Save data with timestamp
  static Future<void> saveDataOffline(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dataKey, json.encode(data));
    await prefs.setInt(
        _syncTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Retrieve offline data with sync info
  static Future<Map<String, dynamic>?> getOfflineData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson = prefs.getString(_dataKey);
    final syncTimestamp = prefs.getInt(_syncTimestampKey);

    return dataJson != null
        ? {'data': json.decode(dataJson), 'lastSyncTimestamp': syncTimestamp}
        : null;
  }

  // Check if data needs synchronization
  static Future<bool> needsSynchronization() async {
    final offlineData = await getOfflineData();
    if (offlineData == null) return false;

    final lastSyncTimestamp = offlineData['lastSyncTimestamp'];
    final hoursSinceSync = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastSyncTimestamp))
        .inHours;

    return hoursSinceSync > 24; // Sync if older than 24 hours
  }
}
