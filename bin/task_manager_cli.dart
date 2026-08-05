

import 'dart:io';

import 'package:task_manager_cli/repository/json_task_repository.dart';
import 'package:task_manager_cli/services/cli_service.dart';
import 'package:task_manager_cli/services/task_manager_service.dart';

Future<void> main(List<String> arguments) async {
  final storagePath = 'data/tasks.json';
  final repository = JsonTaskRepository(storagePath);
  
  try {
    await repository.load();
  } catch (e) {
    print("Attention: Impossible d'initialiser le stockage : $e");
  }

  final service = TaskManagerService(repository);
  final cli = CliService(service);

  await cli.start();

  exit(0);
}