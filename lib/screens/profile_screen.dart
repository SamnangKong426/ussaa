import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final String avatarImg = 'assets/images/profile.png';

  final List tasksOverview = [
    {'title': 'Tasks Completed', 'count': '10', "color": Colors.green[100]},
    {'title': 'Tasks Pending', 'count': '5', "color": Colors.red[100]},
  ];

  List<Widget> getTasksOverview() {
    return tasksOverview.asMap().entries.map((entry) {
      int i = entry.key;
      var task = entry.value;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.only(right: i < tasksOverview.length - 1 ? 10 : 0),
          decoration: BoxDecoration(
            color: task['color'],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(task['count'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(task['title'], style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }).toList();
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
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Nothing is impossible', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
            title: const Text('Profile'),
            backgroundColor: Colors.white,
          ),
          profileAvatar,
          const SizedBox(height: 20),
          const Text('Tasks Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...getTasksOverview(),
            ],
          ),
        ],
      ),
    );
  }
}
