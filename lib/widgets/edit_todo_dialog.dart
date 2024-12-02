import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advanced_app/models/todo_model.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo todo;

  const EditTodoDialog({super.key, required this.todo});

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late int _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
    _priority = widget.todo.priority;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
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
          onPressed: _updateTodo,
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _updateTodo() {
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

    // Create updated Todo
    final updatedTodo = Todo(
      id: widget.todo.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      priority: _priority,
      isCompleted: widget.todo.isCompleted,
      createdAt: widget.todo.createdAt,
      completedAt: widget.todo.completedAt,
    );

    // Update todo using Provider
    Provider.of<TodoModel>(context, listen: false).updateTodo(updatedTodo);

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
