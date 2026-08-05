

import '../models/simple_task.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';
import '../repository/repository.dart';

enum SortOption {none, byPriority, byDate}

class TaskManagerService {
  final Repository<Task> _repository;

  TaskManagerService(this._repository);

  Future<Task> addSimpleTask(String title, Priority priority) async {
    final task = SimpleTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
    );
    await _repository.add(task);
    return task;
  }

  Future<Task> addUrgentTask(String title, Priority priority, DateTime deadline) async {
    final task = UrgentTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
      deadline: deadline,
    );
    await _repository.add(task);
    return task;
  }

  Future<List<Task>> getTasks({SortOption sortBy = SortOption.none}) async {
    final tasks = List<Task>.from(await _repository.getAll());

    switch (sortBy) {
      case SortOption.byPriority:
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;

      case SortOption.byDate:
        tasks.sort((a, b) {
          if (a is UrgentTask && b is UrgentTask) {
            return a.deadline.compareTo(b.deadline);
          } else if (a is UrgentTask) {
            return -1;
          } else if (b is UrgentTask) {
            return 1;
          }
          return 0;
        });
      break;

      case SortOption.none:
        break;
    }

    return tasks;
  }

  Future<void> toggleTaskStatus(String id) async {
    final task = await _repository.getById(id);
    if (task != null) {
      task.toggleCompleted();
      await _repository.update(task);
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.delete(id);
  }
}