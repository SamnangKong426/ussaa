import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';
import 'package:ussaa/widgets/category_button.dart';
import 'package:ussaa/widgets/new_task.dart';
import 'package:ussaa/widgets/task_list.dart';

class TaskScreen extends StatefulWidget {
  final List<TaskModel> taskList;

  const TaskScreen({super.key, required this.taskList});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<List<dynamic>> category = [
    ['ALL', true],
    ['WORK', false],
    ['PERSONAL', false],
    ['SHOPPING', false],
    ['OTHERS', false],
  ];

  List<Widget> getCategoryButtons() {
    return category.map((category) {
      return CategoryButton(
        categoryName: category[0] as String,
        isActive: category[1] as bool,
        onPressed: () {
          print("Button clicked: ${category[0]}");
        },
      );
    }).toList();
  }

  bool _isTaskTodayShow = true;
  IconData _iconTask = Icons.arrow_drop_down;

  bool _isCompletedTaskTodayShow = true;
  IconData _iconCompletedTaks = Icons.arrow_drop_down;

  void _toggle_task_today() {
    setState(() {
      _isTaskTodayShow = !_isTaskTodayShow;
      _iconTask =
          _isTaskTodayShow ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    });
  }

  void _toggle_completed_task_today() {
    setState(() {
      _isCompletedTaskTodayShow = !_isCompletedTaskTodayShow;
      _iconCompletedTaks = _isCompletedTaskTodayShow
          ? Icons.arrow_drop_up
          : Icons.arrow_drop_down;
    });
  }

  void completeTask(TaskModel task) {
    setState(() {
      int index = widget.taskList.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        widget.taskList[index].isCompleted =
            !widget.taskList[index].isCompleted;
      }
    });
  }

  Future<void> updateTask(TaskModel editingTask) async {
    final result = await Navigator.push<TaskModel>(
        context,
        MaterialPageRoute(
            builder: (context) => NewTask(
                  taskmode: TaskMode.editing,
                  task: editingTask,
                )));
    print(result);
    if (result != null) {
      setState(() {
        // Update the task in the list
        int index =
            widget.taskList.indexWhere((task) => task.id == editingTask.id);
        if (index != -1) {
          widget.taskList[index] = result;
        }
      });
    }
  }

  void deleteTask(TaskModel task) {
    setState(() {
      widget.taskList.removeWhere((t) => t.id == task.id);
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: ListView(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            children: getCategoryButtons(),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(_iconTask, color: Colors.black, size: 30),
                onPressed: () {
                  _toggle_task_today();
                },
              ),
            ],
          ),
        ),
        if (_isTaskTodayShow)
          Expanded(
            child: TaskList(
                taskList: widget.taskList,
                completeTaskList: completeTask,
                updateTaskList: updateTask,
                deleteTaskList: deleteTask,
                mode: TaskListMode.pending),
          ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Text(
                'Completed Today',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(_iconCompletedTaks, color: Colors.black, size: 30),
                onPressed: () {
                  _toggle_completed_task_today();
                },
              ),
            ],
          ),
        ),
        if (_isCompletedTaskTodayShow)
          Expanded(
            child: TaskList(
              taskList: widget.taskList,
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
