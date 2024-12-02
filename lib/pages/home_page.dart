// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advanced_app/models/todo_model.dart';
import 'package:advanced_app/widgets/todo_list_item.dart';
import 'package:advanced_app/widgets/add_todo_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Todo> _filteredTodos = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoModel>(context, listen: false).loadTodos();
    });
  }

  void _filterTodos(String query, List<Todo> todos) {
    setState(() {
      _filteredTodos = todos
          .where((todo) =>
              todo.title.toLowerCase().contains(query.toLowerCase()) ||
              (todo.description?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text('Advanced Todo App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.deepPurple.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                final todos =
                    Provider.of<TodoModel>(context, listen: false).todos;
                _filterTodos(value, todos);
              },
            ),
          ),
          Expanded(
            child: Consumer<TodoModel>(
              builder: (context, todoModel, child) {
                final todosToShow = _searchController.text.isNotEmpty
                    ? _filteredTodos
                    : todoModel.todos;

                if (todosToShow.isEmpty) {
                  return const Center(
                    child: Text(
                      'No todos yet. Add your first todo!',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: todosToShow.length,
                  itemBuilder: (context, index) {
                    return TodoListItem(todo: todosToShow[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Todos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                final todos =
                    Provider.of<TodoModel>(context, listen: false).todos;
                setState(() {
                  _filteredTodos =
                      todos.where((todo) => todo.isCompleted).toList();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Completed Todos'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final todos =
                    Provider.of<TodoModel>(context, listen: false).todos;
                setState(() {
                  _filteredTodos =
                      todos.where((todo) => !todo.isCompleted).toList();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Pending Todos'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final todos =
                    Provider.of<TodoModel>(context, listen: false).todos;
                setState(() {
                  _filteredTodos = todos;
                });
                Navigator.of(context).pop();
              },
              child: const Text('All Todos'),
            ),
          ],
        ),
      ),
    );
  }
}
