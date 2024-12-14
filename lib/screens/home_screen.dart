import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';
import 'package:ussaa/screens/task_screen.dart';
import 'package:ussaa/screens/timer_screen.dart';
import 'package:ussaa/widgets/new_task.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ussaa/screens/calendar_screen.dart';
import 'package:ussaa/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<TaskModel> _taskList = taskList;
  final List<Widget> _screenList = [
    TaskScreen(taskList: taskList),
    const TimerScreen(),
    const CalendarScreen(),
    ProfileScreen(),
  ];

  void _updateScreenList() {
    setState(() {
      _screenList[0] = TaskScreen(taskList: _taskList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenList,
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavBar(),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.blue.shade600,
              onPressed: _createTask,
              child: const Icon(Icons.create, color: Colors.white),
            )
          : null,
    );
  }

  Future<void> _createTask() async {
    TaskModel task = TaskModel(
      title: '',
      description: '',
      category: TaskCategory.Work,
      date: DateTime.now(),
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay.now(),
    );
    final result = await Navigator.push<TaskModel>(
        context,
        MaterialPageRoute(
            builder: (context) => NewTask(
                  taskmode: TaskMode.creating,
                  task: task,
                )));
    print(result);
    if (result != null) {
      setState(() {
        _taskList.add(result);
        _updateScreenList();
      });
    }
  }

  BottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: Colors.black,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: Colors.grey[100]!,
        color: Colors.black,
        tabs: const [
          GButton(
            icon: LineIcons.home,
            text: 'Tasks',
          ),
          GButton(icon: LineIcons.clock, text: 'Timer'),
          GButton(
            icon: LineIcons.calendar,
            text: 'Calendar',
          ),
          GButton(
            icon: LineIcons.user,
            text: 'Profile',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
