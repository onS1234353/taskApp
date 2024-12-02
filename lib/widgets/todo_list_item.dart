// widgets/todo_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:advanced_app/models/todo_model.dart';
import 'package:advanced_app/widgets/edit_todo_dialog.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;

  const TodoListItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _showEditDialog(context),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _deleteTodo(context),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _getColorBasedOnPriority(todo.priority),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (value) => _toggleTodoStatus(context),
              activeColor: Colors.white,
              checkColor: Colors.black,
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                color: Colors.white,
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: todo.description != null
                ? Text(
                    todo.description!,
                    style: const TextStyle(color: Colors.white70),
                  )
                : null,
            trailing: Text(
              _formatDate(todo.createdAt!),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorBasedOnPriority(int priority) {
    switch (priority) {
      case 3:
        return Colors.red.shade600;
      case 2:
        return Colors.orange.shade600;
      default:
        return Colors.deepPurple;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _toggleTodoStatus(BuildContext context) {
    final todoModel = Provider.of<TodoModel>(context, listen: false);
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
      createdAt: todo.createdAt,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
      priority: todo.priority,
    );

    todoModel.updateTodo(updatedTodo);
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditTodoDialog(todo: todo),
    );
  }

  void _deleteTodo(BuildContext context) {
    final todoModel = Provider.of<TodoModel>(context, listen: false);
    todoModel.deleteTodo(todo);
  }
}
