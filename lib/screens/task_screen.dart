import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:ussaa/models/task_model.dart';
import 'package:ussaa/services/database_service.dart';
import 'package:ussaa/widgets/category_button.dart';
import 'package:ussaa/widgets/new_task.dart';
import 'package:ussaa/widgets/task_list.dart';
import 'dart:async';
import 'package:ussaa/services/notification_service.dart';

class TaskScreen extends StatefulWidget {
  final List<Task> taskList;
  const TaskScreen({super.key, required this.taskList});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TaskType selectedCategory = TaskType.all;
  final AppDatabase db = AppDatabase.instance;

  final List<List<dynamic>> category = [
    ['ALL', TaskType.all],
    ['PLAN', TaskType.planned],
    ['URGENT', TaskType.urgent],
    // Add other categories as needed
  ];

  List<Widget> getCategoryButtons() {
    return category.map((category) {
      return CategoryButton(
        categoryName: category[0] as String,
        isActive: selectedCategory == category[1],
        onPressed: () {
          setState(() {
            selectedCategory = category[1] as TaskType;
          });
        },
      );
    }).toList();
  }

  bool _isTaskTodayShow = true;
  IconData _iconTask = Icons.arrow_drop_down;

  bool _isCompletedTaskTodayShow = true;
  IconData _iconCompletedTaks = Icons.arrow_drop_down;

  void _showTaskToday() {
    setState(() {
      _isTaskTodayShow = !_isTaskTodayShow;
      _iconTask =
          _isTaskTodayShow ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    });
  }

  void _showCompletedTaskToday() {
    setState(() {
      _isCompletedTaskTodayShow = !_isCompletedTaskTodayShow;
      _iconCompletedTaks = _isCompletedTaskTodayShow
          ? Icons.arrow_drop_up
          : Icons.arrow_drop_down;
    });
  }

  void completeTask(Task task) {
    setState(() {
      int index = widget.taskList.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        widget.taskList[index] = task.copyWith(isDone: !task.isDone);
        db.updateTask(widget.taskList[index]);
      }
    });
  }

  Future<void> updateTask(Task editingTask) async {
    final result = await Navigator.push<Task>(
        context,
        MaterialPageRoute(
            builder: (context) => NewTask(
                  taskmode: TaskMode.editing,
                  task: editingTask,
                )));
    if (result != null) {
      setState(() {
        int index =
            widget.taskList.indexWhere((task) => task.id == editingTask.id);
        if (index != -1) {
          widget.taskList[index] = result;
          db.updateTask(result);
        }
      });
    }
  }

  void deleteTask(Task task) {
    print(task);
    setState(() {
      widget.taskList.removeWhere((t) => t.id == task.id);
      db.deleteTask(task);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.taskList.add(task);
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTaskNotificationTimer();
  }

  void startTaskNotificationTimer() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      checkTaskStartTime();
    });
  }

  void checkTaskStartTime() {
    DateTime now = DateTime.now();
    for (var task in widget.taskList) {
      if (!task.isDone) {
        DateTime taskStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          task.dueDate.hour,
          task.dueDate.minute,
        );
        if (taskStartTime.difference(now).inMinutes <= 1 &&
            taskStartTime.day == task.dueDate.day &&
            taskStartTime.month == task.dueDate.month &&
            taskStartTime.year == task.dueDate.year) {
          NotificationService.showNotification(
            title: 'Task Reminder',
            body:
                'Your task "${task.title}" is about to start in ${taskStartTime.difference(now).inMinutes} minutes.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: ListView(
            padding: const EdgeInsets.only(left: 5),
            scrollDirection: Axis.horizontal,
            children: getCategoryButtons(),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(_iconTask, color: Colors.black, size: 30),
                onPressed: () {
                  _showTaskToday();
                },
              ),
            ],
          ),
        ),
        if (_isTaskTodayShow)
          Flexible(
            child: TaskList(
                taskList: widget.taskList
                    .where((task) => task.taskType == selectedCategory)
                    .toList(),
                completeTaskList: completeTask,
                updateTaskList: updateTask,
                deleteTaskList: deleteTask,
                mode: TaskListMode.pending),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text(
                'Completed Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(_iconCompletedTaks, color: Colors.black, size: 30),
                onPressed: () {
                  _showCompletedTaskToday();
                },
              ),
            ],
          ),
        ),
        if (_isCompletedTaskTodayShow)
          Flexible(
            child: TaskList(
              taskList: widget.taskList
                  .where((task) => task.taskType == selectedCategory)
                  .toList(),
              completeTaskList: completeTask,
              updateTaskList: updateTask,
              deleteTaskList: deleteTask,
              mode: TaskListMode.completed,
            ),
          ),
      ],
    );
  }
}
