// widgets/add_todo_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advanced_app/models/todo_model.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _priority = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Todo Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Description (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Priority:'),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: _priority,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Low')),
                  DropdownMenuItem(value: 2, child: Text('Medium')),
                  DropdownMenuItem(value: 3, child: Text('High')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTodo,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveTodo() {
    // Validate title is not empty
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo title cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create new Todo
    final newTodo = Todo(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      priority: _priority,
      createdAt: DateTime.now(),
    );

    // Add todo using Provider
    Provider.of<TodoModel>(context, listen: false).addTodo(newTodo);

    // Close the dialog
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // Clean up controllers
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
