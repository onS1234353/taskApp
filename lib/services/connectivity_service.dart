import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  // Network state management
  ValueNotifier<bool> isConnectedNotifier = ValueNotifier(true);

  // Check current connection status
  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnectedNotifier.value = connectivityResult != ConnectivityResult.none;
  }

  // Listen to connectivity changes
  void startListening() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isConnectedNotifier.value = result != ConnectivityResult.none;
    });
  }

  // Offline sync strategy
  Future<void> syncOfflineData() async {
    if (await isConnected()) {
      // Implement your sync logic here
      // e.g., push offline todos to a backend
    }
  }

  // Check if currently connected
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
