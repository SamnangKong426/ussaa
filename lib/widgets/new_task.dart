import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';

enum TaskMode { creating, editing }

class NewTask extends StatefulWidget {
  NewTask({super.key, required this.taskmode, required this.task});

  final TaskMode taskmode;
  final TaskModel task;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;
  TaskCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    if (widget.taskmode == TaskMode.editing) {
      _taskTitleController.text = widget.task.title;
      _taskDescriptionController.text = widget.task.description;
      _selectedCategory = widget.task.category;
      _selectedDate = widget.task.date;
      _selectedStartTime = widget.task.startTime;
      _selectedEndTime = widget.task.endTime;
    }
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  bool get creatingMode => widget.taskmode == TaskMode.creating;
  bool get editingMode => widget.taskmode == TaskMode.editing;

  String get headerLabel => creatingMode ? "Add a new item" : "Edit item";
  String get buttonLabel => creatingMode ? "Add" : "Edit";

  String get titleLabel => creatingMode ? "Task name" : widget.task.title;
  String get descriptionLabel =>
      creatingMode ? "Task description" : widget.task.description;

  String get categoryLabel => creatingMode
      ? "Select a category"
      : widget.task.category.toString().split('.').last;
  String get dateLabel => _selectedDate.toString().split(' ')[0];
  String get startTimeLabel => _selectedStartTime.format(context);
  String get endTimeLabel => _selectedEndTime.format(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text(headerLabel),
            ),
            TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(
                labelText: titleLabel,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _taskDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Task description',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton(
              hint: _selectedCategory == null
                  ? const Text('Select a category')
                  : Text(_selectedCategory.toString().split('.').last),
              items: TaskCategory.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString().split('.').last),
                      ))
                  .toList(),
              onChanged: _onSeleteCategory,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.access_time_rounded),
                const SizedBox(width: 10),
                TextButton(onPressed: _selectDate, child: Text(dateLabel)),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: _selectStartTime,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black54),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10)),
                  ),
                  child: Text(startTimeLabel),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: _selectEndTime,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black54),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10)),
                  ),
                  child: Text(endTimeLabel),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: _onReset, child: const Text('Reset')),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: _onSave, child: Text(buttonLabel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onReset() {
    setState(() {
      _taskTitleController.clear();
      _taskDescriptionController.clear();
      _selectedCategory = null;
      _selectedDate = DateTime.now();
      _selectedStartTime = TimeOfDay.now();
      _selectedEndTime = TimeOfDay.now();
    });
  }

  void _onSave() {
    // print("Task title: ${_taskTitleController.text}");
    // print("Task description: ${_taskDescriptionController.text}");
    // print("Category: $_selectedCategory");
    // print("Start time: ${_selectedStartTime.format(context)} ${_selectedStartTime.period == DayPeriod.am ? 'AM' : 'PM'}");
    // print("End time: ${_selectedEndTime.format(context)} ${_selectedEndTime.period == DayPeriod.am ? 'AM' : 'PM'}");

    if (_taskTitleController.text.isEmpty ||
        _taskDescriptionController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    TaskModel task = TaskModel(
      title: _taskTitleController.text,
      description: _taskDescriptionController.text,
      category: _selectedCategory!,
      date: _selectedDate,
      startTime: _selectedStartTime,
      endTime: _selectedEndTime,
    );

    Navigator.pop(context, task);
  }

  void _onSeleteCategory(TaskCategory? value) {
    setState(() {
      _selectedCategory = value!;
    });
  }

  void _selectStartTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: _selectedStartTime,
        initialEntryMode: TimePickerEntryMode.inputOnly);
    setState(() {
      if (timeOfDay != null) _selectedStartTime = timeOfDay;
    });
  }

  void _selectEndTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: _selectedEndTime,
        initialEntryMode: TimePickerEntryMode.inputOnly);
    setState(() {
      if (timeOfDay != null) _selectedEndTime = timeOfDay;
    });
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    setState(() {
      if (_picked != null) _selectedDate = _picked;
    });
  }
}
