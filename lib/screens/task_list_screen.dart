import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _editTask(Task task, int index) {
    setState(() {
      tasks[index] = task;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _navigateToForm(BuildContext context, [Task? task, int? index]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          task: task,
        ),
      ),
    );

    if (result != null && result is Task) {
      if (index != null) {
        _editTask(result, index);
      } else {
        _addTask(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          String convertedDateTime = "Dia ${task.dateTime.day}/${task.dateTime.month}/${task.dateTime.year} Hora ${task.dateTime.hour}:${task.dateTime.minute}";
          String locationInfo = task.location.isNotEmpty ? task.location : "Localização: ${task.latitude}, ${task.longitude}";
          String texto = "$convertedDateTime\n$locationInfo";
          return ListTile(
            title: Text(task.name),
            subtitle: Text(texto),
            onTap: () => _navigateToForm(context, task, index),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToForm(context),
      ),
    );
  }
}
