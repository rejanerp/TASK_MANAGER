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
        title: const Text('Gerenciador de tarefas.'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          String convertedDateTime = "Dia ${task.dateTime.day.toString()}/${task.dateTime.month.toString()}/${task.dateTime.year.toString()} Hora ${task.dateTime.hour.toString()}:${task.dateTime.minute.toString()} ";
          String geoLocalizacao = "Localização '${task.latitude}- ${task.longitude}'";
          String texto = convertedDateTime + geoLocalizacao;
          return ListTile(
            title: Text(task.name),
            subtitle: Text(texto) , //Text('${task.dateTime} - ${task.latitude}, ${task.longitude}'),
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
