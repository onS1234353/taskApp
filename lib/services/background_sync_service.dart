import 'package:workmanager/workmanager.dart';
import 'package:advanced_app/services/connectivity_service.dart';
import 'package:advanced_app/services/offline_storage_service.dart';
import 'package:advanced_app/services/todo_database.dart';

class BackgroundSyncService {
  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    // Register periodic sync tasks
    Workmanager().registerPeriodicTask(
      'todo-sync',
      'periodicSync',
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }

  static void registerOneTimeSync() {
    Workmanager().registerOneOffTask(
      'one-time-sync',
      'syncTask',
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}

// Global callback dispatcher for background tasks
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      final connectivityService = ConnectivityService();

      // Check if network is available
      if (await connectivityService.isConnected()) {
        // Process offline queue
        final offlineQueue = await OfflineQueueService.getOfflineQueue();

        for (var operation in offlineQueue) {
          switch (operation['type']) {
            case 'add':
              await TodoDatabase.insertTodo(operation['todo']);
              break;
            case 'update':
              await TodoDatabase.updateTodo(operation['todo']);
              break;
            case 'delete':
              await TodoDatabase.deleteTodo(operation['todoId']);
              break;
          }
        }

        // Clear the offline queue after processing
        await OfflineQueueService.clearOfflineQueue();
      }

      return Future.value(true);
    } catch (e) {
      print("Background sync failed: $e");
      return Future.value(false);
    }
  });
}
