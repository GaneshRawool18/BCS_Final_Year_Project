import 'package:advance_digital_notepad/controller/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TasksForDatePage extends StatelessWidget {
  final DateTime date;
  const TasksForDatePage({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ToDoController toDoController = Get.find<ToDoController>();
    // Use the same date format "MM/dd/yyyy"
    final DateFormat dateFormat = DateFormat('MM/dd/yyyy');
    String formattedDate = dateFormat.format(date);
    // Filter tasks using the same format
    var tasksForDate = toDoController.taskList
        .where((task) => task.date == formattedDate)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Tasks on $formattedDate')),
      body: tasksForDate.isNotEmpty
          ? ListView.builder(
              itemCount: tasksForDate.length,
              itemBuilder: (context, index) {
                var task = tasksForDate[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.task, color: Colors.blue),
                    title: Text(task.title),
                    subtitle: Text("Due: ${task.date}"),
                  ),
                );
              },
            )
          : const Center(child: Text('No tasks for this day.')),
    );
  }
}
