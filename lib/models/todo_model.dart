// models/todo_model.dart
import 'package:flutter/foundation.dart';
import 'package:advanced_app/services/todo_database.dart';

class Todo {
  int? id;
  String title;
  bool isCompleted;
  DateTime? createdAt;
  DateTime? completedAt;
  String? description;
  int priority;

  Todo({
    this.id,
    required this.title,
    this.isCompleted = false,
    this.createdAt,
    this.completedAt,
    this.description,
    this.priority = 1,
  }) {
    createdAt ??= DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'description': description,
      'priority': priority,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int?,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      description: map['description'] as String?,
      priority: (map['priority'] as int?) ?? 1,
    );
  }
}

class TodoModel extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await TodoDatabase.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await TodoDatabase.insertTodo(todo);
    await loadTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await TodoDatabase.updateTodo(todo);
    await loadTodos();
  }

  Future<void> deleteTodo(Todo todo) async {
    await TodoDatabase.deleteTodo(todo.id!);
    await loadTodos();
  }

  // In TodoModel or a connectivity listener
  void checkAndSyncOfflineOperations() async {
    await TodoDatabase.syncOfflineOperations();
    await loadTodos(); // Refresh the list
  }
}
