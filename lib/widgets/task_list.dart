import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';

enum TaskListMode {
  completed,
  pending,
}

class TaskList extends StatelessWidget {
  final List<TaskModel> taskList;
  final Function(TaskModel) completeTaskList;
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
          ? task.isCompleted
          : !task.isCompleted;
    }).toList();

    return ListView.builder(
      itemCount: filteredTaskList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Card(
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  filteredTaskList[index].isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: filteredTaskList[index].isCompleted
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
              onLongPress: () {
                deleteTaskList(filteredTaskList[index]);
              },
              contentPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    filteredTaskList[index].title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filteredTaskList[index].startTime.format(context)} ${filteredTaskList[index].startTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                  ),
                ],
              ),
              subtitle: Text(filteredTaskList[index].description),
            ),
          ),
        );
      },
    );
  }
}
