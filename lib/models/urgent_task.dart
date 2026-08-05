import 'task.dart';

class UrgentTask extends Task {
  final DateTime deadline;

  UrgentTask({
    required super.id,
    required super.title,
    required super.priority,
    required this.deadline,
    super.isCompleted,
  });

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(id: json['id'], title: json['title'], priority: Priority.values.byName(json['priority']), deadline: DateTime.parse(json['deadline']), isCompleted: json['isCompleted'] ?? false);
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['type'] = 'urgent';
    map['deadline'] = deadline.toIso8601String();

    return map;
  }

  @override
  String getSummary() {
    final status = isCompleted ? '[X]' : '[ ]';
    final dateFormatted = "${deadline.day}/${deadline.month}/${deadline.year}";

    return '$status URGENT: $title (Avant le: $dateFormatted | Priorité: ${priority.name.toUpperCase()})';
  }
}