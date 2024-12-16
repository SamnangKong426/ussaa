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
        return Container(
          margin: const EdgeInsets.all(5),
          child: Card(
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
              onLongPress: () {
                deleteTaskList(filteredTaskList[index]);
              },
              contentPadding: const EdgeInsets.all(5),
              title: Row(
                children: [
                  Text(
                    filteredTaskList[index].title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filteredTaskList[index].dueDate.toString().split(' ')[0]} ${TimeOfDay.fromDateTime(filteredTaskList[index].dueDate).format(context)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: Text(filteredTaskList[index].description ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  )),
            ),
          ),
        );
      },
    );
  }
}
