import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advanced_app/models/todo_model.dart';
import 'package:advanced_app/pages/home_page.dart';
import 'package:advanced_app/services/connectivity_service.dart';
import 'package:advanced_app/services/background_sync_service.dart';
import 'package:advanced_app/services/todo_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sync any offline operations on app start
  await TodoDatabase.syncOfflineOperations();

  // Initialize services
  final connectivityService = ConnectivityService();
  connectivityService.checkConnectivity();
  connectivityService.startListening();

  // Initialize background sync
  BackgroundSyncService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoModel()),
        Provider.value(value: connectivityService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
