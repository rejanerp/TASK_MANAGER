import 'package:flutter/material.dart';
import 'package:task_manager/screens/task_list_screen.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Define a cor primária para o aplicativo
        scaffoldBackgroundColor: Color.fromARGB(255, 246, 171, 196)
      ),
      home: TaskListScreen(),
    );
  }
}
