import 'package:flutter/material.dart';
import 'package:ussaa/screens/home_screen.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final String title = 'Welcome to Ussaa';
  final features = [
    {
      'icon': 'assets/icons/task_icon.png',
      'title': 'Create Tasks Quickly and Easily',
      'description': 'Input tasks, subtasks and repetitive tasks.'
    },
    {
      'icon': 'assets/icons/reminder_icon.png',
      'title': 'Task Reminders',
      'description': 'Set reminders, and never miss your important tasks'
    },
    {
      'icon': 'assets/icons/widget_icon.png',
      'title': 'Personalized Widgets',
      'description': 'Create widgets, and view your tasks more easily'
    },
    {
      'icon': 'assets/icons/project_icon.png',
      'title': 'Project Managements',
      'description': 'More project templates, reusable, and easy to manage'
    }
  ];

  final List<Color> colors = [
    const Color.fromRGBO(60, 60, 67, 60),
    Colors.black,
    const Color.fromRGBO(5, 147, 255, 100)
  ];

  List<Widget> getFeatureWidgets() {
    return features.map((feature) {
      return Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Image.asset(feature['icon']!, width: 50, height: 50),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['title']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors[1],
                    ),
                  ),
                  Text(
                    feature['description']!,
                    style: TextStyle(
                        fontSize: 12,
                        color: colors[0],
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: orientation == Orientation.portrait
                ? _buildPortraitLayout(context)
                : _buildLandscapeLayout(context),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors[1],
              ),
            ),
            const SizedBox(height: 20),
            ...getFeatureWidgets(),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: colors[2],
          ),
          child: const Text(
            'CONTINUE >>>',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors[1],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...getFeatureWidgets().sublist(0, 2),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 44), // To align with the title on the left
                  ...getFeatureWidgets().sublist(2, 4),
                ],
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: colors[2],
          ),
          child: const Text(
            'CONTINUE >>>',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
