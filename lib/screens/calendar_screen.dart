import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ussaa/models/task_model.dart';
import 'package:ussaa/services/database_service.dart';
import 'package:ussaa/widgets/task_timeline.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.taskList});
  final List<Task> taskList;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      print(today);
      print(widget.taskList);
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.taskList);
    
  }

  @override
  Widget build(BuildContext context) {
    final filteredTaskList = widget.taskList.where((task) {
      return task.dueDate.day == today.day &&
             task.dueDate.month == today.month &&
             task.dueDate.year == today.year;
    }).toList()
      ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          TableCalendar(
            locale: 'en_US',
            rowHeight: 40,
            daysOfWeekHeight: 40,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(day, today),
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(height: 10),
          TaskTimeline(taskList: filteredTaskList),
        ],
      ),
    );
  }
}
