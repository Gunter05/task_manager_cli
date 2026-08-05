import 'json_encodable.dart';

enum Priority { low, medium, high }

abstract class Task implements JsonEncodable {
  final String id;
  String title;
  Priority priority;
  bool isCompleted;

  Task ({
    required this.id,
    required this.title,
    required this.priority,
    this.isCompleted = false,
  });

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  String getSummary();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'isCompleted': isCompleted,
    };
  }
}