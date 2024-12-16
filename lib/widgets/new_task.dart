import 'package:flutter/material.dart';
import 'package:ussaa/models/task_model.dart';

enum TaskMode { creating, editing }

class NewTask extends StatefulWidget {
  const NewTask({super.key, required this.taskmode, required this.task});
  final TaskMode taskmode;
  final Task task;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;
  TaskType? _selectedCategory;
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    if (widget.taskmode == TaskMode.editing) {
      _taskTitleController.text = widget.task.title;
      _taskDescriptionController.text = widget.task.description!;
      _selectedCategory = widget.task.taskType;
      _selectedDateTime = widget.task.dueDate;
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
      creatingMode ? "Task description" : widget.task.description!;

  String get categoryLabel => creatingMode
      ? "Select a category"
      : widget.task.taskType.toString().split('.').last;
  String get dateTimeLabel => '${_selectedDateTime.toLocal()}'.split(' ')[0] + ' ' + TimeOfDay.fromDateTime(_selectedDateTime).format(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text(headerLabel, style: const TextStyle(fontSize: 20)),
                backgroundColor: Colors.transparent,
              ),
              _buildTextField(_taskTitleController, titleLabel),
              const SizedBox(height: 10),
              _buildTextField(_taskDescriptionController, 'Task description'),
              const SizedBox(height: 10),
              _buildDropdownButton(),
              const SizedBox(height: 20),
              _buildDateTimeButton(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButton(
      hint: _selectedCategory == null
          ? const Text('Select a category')
          : Text(_selectedCategory.toString().split('.').last),
      items: TaskType.values
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString().split('.').last),
              ))
          .toList(),
      onChanged: _onSeleteCategory,
    );
  }

  Widget _buildDateTimeButton() {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        const SizedBox(width: 10),
        TextButton(
          onPressed: _selectDateTime,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black54),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
          ),
          child: Text(dateTimeLabel),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed: _onReset, child: const Text('Reset')),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: _onSubmit, child: Text(buttonLabel)),
        ],
      ),
    );
  }

  void _onReset() {
    setState(() {
      _taskTitleController.clear();
      _taskDescriptionController.clear();
      _selectedCategory = null;
      _selectedDateTime = DateTime.now();
    });
  }

  void _onSubmit() {
    if (_taskTitleController.text.isEmpty ||
        _taskDescriptionController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    final task = Task(
      title: _taskTitleController.text,
      description: _taskDescriptionController.text,
      taskType: _selectedCategory!,
      dueDate: _selectedDateTime,
    );

    Navigator.pop(context, task);
  }

  void _onSeleteCategory(TaskType? value) {
    setState(() {
      _selectedCategory = value!;
    });
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
}
