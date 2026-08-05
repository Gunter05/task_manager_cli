import 'task.dart';

class SimpleTask extends Task {
  SimpleTask({
    required super.id,
    required super.title,
    required super.priority,
    super.isCompleted,
  });

  factory SimpleTask.fromJson(Map<String, dynamic> json) {
    return SimpleTask(id: json['id'], title: json['title'], priority: Priority.values.byName(json['priority']), isCompleted: json['isCompleted'] ?? false);
  }

  @override
  String getSummary() {
    final status = isCompleted ? '[X]' : '[ ]';
    return '$status $title (Priorité: ${priority.name.toUpperCase()})';
  }
}