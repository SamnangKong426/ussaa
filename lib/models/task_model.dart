
enum TaskType { all, planned, urgent }

extension TaskTypeExtension on TaskType {
  String get name {
    switch (this) {
      case TaskType.all:
        return 'All';
      case TaskType.planned:
        return 'Planned';
      case TaskType.urgent:
        return 'Urgent';
      default:
        return '';
    }
  }

  static TaskType getTaskType(String taskType) {
    switch (taskType) {
      case 'All':
        return TaskType.all;
      case 'Planned':
        return TaskType.planned;
      case 'Urgent':
        return TaskType.urgent;
      default:
        return TaskType.all;
    }
  }
}

const String tableName = 'tasks';
const String idField = '_id';
const String titleField = 'title';
const String descriptionField = 'description';
const String dueDateField = 'due_date';
const String taskTypeField = 'task_type';
const String isDoneField = 'is_done';

const List<String> TaskColumns = [
  idField,
  titleField,
  descriptionField,
  dueDateField,
  taskTypeField,
  isDoneField,
];

const String boolType = "BOOLEAN NOT NULL";
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable = "TEXT";
const String textType = "TEXT NOT NULL";

class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskType taskType;
  final bool isDone;

  const Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.taskType,
    this.isDone = false,
  });

  static Task fromjson(Map<String, dynamic> json) {
    return Task(
      id: json[idField] as int?,
      title: json[titleField] as String,
      description: json[descriptionField] as String?,
      dueDate: DateTime.parse(json[dueDateField] as String),
      taskType: TaskTypeExtension.getTaskType(json[taskTypeField] as String),
      isDone: json[isDoneField] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        idField: id,
        titleField: title,
        descriptionField: description,
        dueDateField: dueDate.toIso8601String(),
        taskTypeField: taskType.name,
        isDoneField: isDone ? 1 : 0,
      };

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskType? taskType,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      taskType: taskType ?? this.taskType,
      isDone: isDone ?? this.isDone,
    );
  }

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json[idField] as int?,
        title: json[titleField] as String,
        description: json[descriptionField] as String?,
        dueDate: DateTime.parse(json[dueDateField] as String),
        taskType: TaskTypeExtension.getTaskType(json[taskTypeField] as String),
        isDone: json[isDoneField] == 1,
      );

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, dueDate: $dueDate, taskType: $taskType, isDone: $isDone}';
  }
}
