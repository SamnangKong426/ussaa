import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum TaskCategory {
  Work,
  Personal,
  Study,
  Health,
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TaskCategory category;
  bool isCompleted;

  TaskModel({
    String? id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.isCompleted = false,
  }) : id = id ?? uuid.v4();

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, date: $date, startTime: $startTime, endTime: $endTime, category: $category, isCompleted: $isCompleted}';
  }
}

List<TaskModel> taskList = [
  TaskModel(
    title: 'Meeting with client',
    description: 'Discuss about the project',
    date: DateTime.now(),
    startTime: TimeOfDay(hour: 10, minute: 0),
    endTime: TimeOfDay(hour: 11, minute: 0),
    category: TaskCategory.Work,
    isCompleted: true,
  ),
  TaskModel(
    title: 'Buy Groceries',
    description: 'Buy vegetables, fruits, etc',
    date: DateTime.now(),
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 13, minute: 0),
    category: TaskCategory.Personal,
  ),
  TaskModel(
    title: 'Call Mom',
    description: 'Call mom and ask about her health',
    date: DateTime.now(),
    startTime: TimeOfDay(hour: 15, minute: 0),
    endTime: TimeOfDay(hour: 15, minute: 30),
    category: TaskCategory.Personal,
  ),
  TaskModel(
    title: 'Meeting with client',
    description: 'Discuss about the project',
    date: DateTime.now(),
    startTime: TimeOfDay(hour: 10, minute: 0),
    endTime: TimeOfDay(hour: 11, minute: 0),
    category: TaskCategory.Work,
    isCompleted: true,
  ),
  TaskModel(
    title: 'Call Mom',
    description: 'Call mom and ask about her health',
    date: DateTime.now(),
    startTime: TimeOfDay(hour: 15, minute: 0),
    endTime: TimeOfDay(hour: 15, minute: 30),
    category: TaskCategory.Personal,
    isCompleted: true,
  ),
];
