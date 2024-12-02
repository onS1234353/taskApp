import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:advanced_app/models/todo_model.dart';
import 'package:advanced_app/services/connectivity_service.dart';

class TodoDatabase {
  static const _todosKey = 'todos_list';

  static Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getStringList(_todosKey) ?? [];

    return todosJson
        .map((todoJson) => Todo.fromMap(json.decode(todoJson)))
        .toList();
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = todos.map((todo) => json.encode(todo.toMap())).toList();

    await prefs.setStringList(_todosKey, todosJson);
  }

  static Future<int> insertTodo(Todo todo) async {
    final todos = await getTodos();
    todo.id = todos.length + 1;
    todos.add(todo);
    await saveTodos(todos);
    return todo.id!;
  }

  static Future<void> updateTodo(Todo updatedTodo) async {
    final todos = await getTodos();
    final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      todos[index] = updatedTodo;
      await saveTodos(todos);
    }
  }

  static Future<void> deleteTodo(int id) async {
    final todos = await getTodos();
    todos.removeWhere((todo) => todo.id == id);
    await saveTodos(todos);
  }

  // Add the syncOfflineOperations method
  static Future<void> syncOfflineOperations() async {
    final connectivityService = ConnectivityService();

    if (await connectivityService.isConnected()) {
      // Implement your offline sync logic here
      // For now, we'll just print a message
      print('Syncing offline operations');

      // You can add more complex synchronization logic here in the future
    }
  }

  static Future<void> initialize() async {
    return Future.value();
  }
}
