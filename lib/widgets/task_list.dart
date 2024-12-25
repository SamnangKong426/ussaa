import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';

enum TaskListMode {
  completed,
  pending,
}

class TaskList extends StatelessWidget {
  final List<Task> taskList;
  final Function(Task) completeTaskList;
  final Function updateTaskList;
  final Function deleteTaskList;
  final TaskListMode mode;

  const TaskList({
    super.key,
    required this.taskList,
    required this.completeTaskList,
    required this.updateTaskList,
    required this.mode,
    required this.deleteTaskList,
  });

  @override
  Widget build(BuildContext context) {
    final filteredTaskList = taskList.where((task) {
      return mode == TaskListMode.completed
          ? task.isDone
          : !task.isDone;
    }).toList();

    return ListView.builder(
      itemCount: filteredTaskList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(filteredTaskList[index].id.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            deleteTaskList(filteredTaskList[index]);
          },
          background: const Icon(Icons.delete, color: Colors.white),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  filteredTaskList[index].isDone
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: filteredTaskList[index].isDone
                      ? Colors.green
                      : Colors.grey,
                ),
                onPressed: () {
                  completeTaskList(filteredTaskList[index]);
                },
              ),
              onTap: () {
                updateTaskList(filteredTaskList[index]);
              },
              // contentPadding: const EdgeInsets.all(16),
              title: Text(
                filteredTaskList[index].title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
