

import 'package:task_manager_cli/exceptions/task_exceptions.dart';
import 'package:task_manager_cli/models/simple_task.dart';
import 'package:task_manager_cli/models/task.dart';
import 'package:task_manager_cli/models/urgent_task.dart';
import 'package:task_manager_cli/repository/repository.dart';
import 'package:task_manager_cli/services/task_manager_service.dart';
import 'package:test/test.dart';

// Implémentation en mémoire du Repository pour les tests
// (sans fichier JSON)
class InMemoryTaskRepository implements Repository<Task> {
  final List<Task> _tasks = [];

  @override
  Future<void> add(Task item) async => _tasks.add(item);

  @override
  Future<void> delete(String id) async {
    final initialLength = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    if (_tasks.length == initialLength) {
      throw TaskNotFoundException(id);
    }
  }

  @override
  Future<List<Task>> getAll() async => List.from(_tasks);

  @override
  Future<Task?> getById(String id) async {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save() async {}

  @override
  Future<void> update(Task item) async {
    final index = _tasks.indexWhere((t) => t.id == item.id);

    if (index == -1) throw TaskNotFoundException(item.id);
  }
}

void main() {
  // Tests sur les modèles de données
  // (Task, SimpleTask, UrgentTask)
  group('Modèles de Tâches', () {
    test('Une nouvelle SimpleTask doit être non terminée par défaut', () {
      final task = SimpleTask(
        id: '1',
        title: 'Réviser mon cours',
        priority: Priority.medium,
    
      );

      expect(task.isCompleted, isFalse);
      expect(task.title, equals('Réviser mon cours'));
    });

    test('toggleCompleted() doit inverser le statut isCompleted', () {
      final task = SimpleTask(
        id: '1',
        title: 'Tester mes connaissances',
        priority: Priority.low,
      );

      task.toggleCompleted();
      expect(task.isCompleted, isTrue);

      task.toggleCompleted();
      expect(task.isCompleted, isFalse);
    });

    test('UrgentTask.toJson() doit inclure la deadline et le type urgent', () {
      final deadline = DateTime(2026, 12, 31);
      final task = UrgentTask(id: '2', title: 'Projet final', priority: Priority.high, deadline: deadline);
      final json = task.toJson();

      expect(json['type'], equals('urgent'));
      expect(json['deadline'], equals(deadline.toIso8601String()));
      expect(json['priority'], equals('high'));
    });
  });

  // Tests sur le service métier
  // (TaskManagerService)
  group('TaskManagerService', () {
    late TaskManagerService service;
    late InMemoryTaskRepository repository;

    setUp(() {
      repository = InMemoryTaskRepository();
      service = TaskManagerService(repository);
    });

    test('getTasks(sortBy: SortOption.byPriority) doit trier du plus fort au plus faible', () async {
      await service.addSimpleTask('Tâche basse', Priority.low);
      await service.addSimpleTask('Tâche haute', Priority.high);
      await service.addSimpleTask('Tâche moyenne', Priority.medium);

      final tasks = await service.getTasks(sortBy: SortOption.byPriority);

      expect(tasks.length, equals(3));
      expect(tasks[0].priority, equals(Priority.high));
      expect(tasks[1].priority, equals(Priority.medium));
      expect(tasks[2].priority, equals(Priority.low));
    });

    test('deleteTask() avec un ID inexistant doit lever TaskNotFoundException', () {
      expect(() async => await service.deleteTask('id_inexistant_999'), throwsA(isA<TaskNotFoundException>()));
    });
  });
}