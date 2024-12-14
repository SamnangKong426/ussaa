import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';
import 'package:ussaa/widgets/new_task.dart';


class NewTask extends StatelessWidget {
  final TaskMode taskmode;
  final TaskModel? task;

  const NewTask({super.key, required this.taskmode, this.task});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: task?.title ?? '');
    final TextEditingController descriptionController = TextEditingController(text: task?.description ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(taskmode == TaskMode.creating ? 'New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            // ...additional fields for date, time, and category...
            ElevatedButton(
              onPressed: () {
                final newTask = TaskModel(
                  title: titleController.text,
                  description: descriptionController.text,
                  date: task?.date ?? DateTime.now(),
                  startTime: task?.startTime ?? TimeOfDay.now(),
                  endTime: task?.endTime ?? TimeOfDay.now(),
                  category: task?.category ?? TaskCategory.Work,
                );
                Navigator.pop(context, newTask);
              },
              child: Text(taskmode == TaskMode.creating ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
