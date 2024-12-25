import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';
import 'package:ussaa/widgets/line_chart_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends StatelessWidget {
  final List<Task> taskList;

  ProfileScreen({super.key, required this.taskList});

  final String avatarImg = 'assets/images/profile.png';

  List<Map<String, dynamic>> get tasksOverview {
    int completedTasks = taskList.where((task) => task.isDone).length;
    int pendingTasks = taskList.length - completedTasks;

    return [
      {
        'title': 'Tasks Completed',
        'count': '$completedTasks',
        "color": Colors.green[100]
      },
      {
        'title': 'Tasks Pending',
        'count': '$pendingTasks',
        "color": Colors.red[100]
      },
    ];
  }

  List<Widget> getTasksOverview() {
    return tasksOverview.asMap().entries.map((entry) {
      int i = entry.key;
      var task = entry.value;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(right: i < tasksOverview.length - 1 ? 10 : 0),
          decoration: BoxDecoration(
            color: task['color'],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(task['count'],
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(task['title'], style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<FlSpot> getTaskDataPoints() {
    List<FlSpot> dataPoints = [];
    for (int i = 0; i < taskList.length; i++) {
      dataPoints.add(FlSpot(i.toDouble(), taskList[i].isDone ? 1 : 0));
    }
    return dataPoints;
  }

  @override
  Widget build(BuildContext context) {
    var profileAvatar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CircleAvatar(
            radius: 50,
            child: Image.asset(avatarImg),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Nothing is impossible', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileAvatar,
              const SizedBox(height: 10),
              const Text('Tasks Overview',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...getTasksOverview(),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 350,
                child: LineChartWidget(dataPoints: getTaskDataPoints()), // Pass dataPoints
              ),
            ],
          ),
        ),
      ],
    );
  }
}
