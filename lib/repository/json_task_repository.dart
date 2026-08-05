

import 'dart:convert';
import 'dart:io';

import '../exceptions/task_exceptions.dart';
import '../models/simple_task.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';
import 'repository.dart';

class JsonTaskRepository implements Repository<Task> {
  final String filePath;
  final List<Task> _tasks = [];

  JsonTaskRepository(this.filePath);

  Future<void> load() async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
      return;
    }

    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) return;

      final List<dynamic> jsonList = jsonDecode(content);
      _tasks.clear();

      for (var jsonItem in jsonList) {
        if (jsonItem['type'] == 'urgent') {
          _tasks.add(UrgentTask.fromJson(jsonItem));
        } else {
          _tasks.add(SimpleTask.fromJson(jsonItem));
        }
      }
    } catch (e) {
      throw InvalidTaskDataException("Impossible de lire le fichier JSON : $e");
    }
  }

  @override
  Future<void> save() async {
    final file = File(filePath);
    final List<Map<String, dynamic>> jsonList = _tasks.map((task) => task.toJson()).toList();

    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(jsonList));
  }

  @override
  Future<List<Task>> getAll() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task?> getById(String id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> add(Task item) async {
    _tasks.add(item);
    await save();
  }

  @override
  Future<void> update(Task item) async {
    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) {
      throw TaskNotFoundException(item.id);
    }
    _tasks[index] = item;
    await save();
  }

  @override
  Future<void> delete(String id) async {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);

    if (_tasks.length == initialLength) {
      throw TaskNotFoundException(id);
    }
    await save();
  }
}