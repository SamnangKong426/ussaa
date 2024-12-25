import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ussaa/screens/home_screen.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
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

  @override
  void initState() {
    super.initState();
    // Enable only portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset preferred orientations to allow both portrait and landscape modes
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: features.map((feature) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    feature['icon']!,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          feature['description']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
