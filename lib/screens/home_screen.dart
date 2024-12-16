import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';
import 'package:ussaa/screens/task_screen.dart';
import 'package:ussaa/screens/timer_screen.dart';
import 'package:ussaa/services/database_service.dart';
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
  List<Task> tasks = [];
  final AppDatabase db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    refreshTaskList();
  }

  Future<void> refreshTaskList() async {
    final List<Task?> taskList = await db.readAllTasks();
    setState(() {
      tasks = taskList.where((task) => task != null).cast<Task>().toList();
      _screenList[0] = TaskScreen(taskList: tasks);
    });
  }

  final List<Widget> _screenList = [
    const TaskScreen(taskList: []),
    const TimerScreen(),
    const CalendarScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screenList,
        ),
        bottomNavigationBar: _buildBottomNavBar(),
        floatingActionButton: _selectedIndex == 0 ? _buildAddTaskButton() : null,
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blue.shade600,
      onPressed: () async {
        Task task = Task(
          title: '',
          description: '',
          taskType: TaskType.today,
          dueDate: DateTime.now(),
        );
        final result = await Navigator.push<Task>(
            context,
            MaterialPageRoute(
                builder: (context) => NewTask(
                      taskmode: TaskMode.creating,
                      task: task,
                    )));
        if (result != null) {
          await db.createTask(result);
          await refreshTaskList();
        }
      },
      child: const Icon(Icons.create, color: Colors.white),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 4,
        activeColor: Colors.black,
        iconSize: 20,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
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
