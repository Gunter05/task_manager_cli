import 'dart:io';

import 'task_manager_service.dart';
import '../exceptions/task_exceptions.dart';
import '../models/task.dart';

class CliService {
  final TaskManagerService _service;

  CliService(this._service);

  Future<void> start() async {
    bool running = true;

    while (running) {
      _printHeader();
      print("1. Ajouter une tâche ");
      print("2. Lister toutles les tâches ");
      print("3. Marquer une tâche commer terminée / non terminée");
      print("4. Supprimer une tâche");
      print("5. Quitter");
      stdout.write("\nVotre choix (1-5) : ");

      final choice = stdin.readLineSync()?.trim();

      try {
        switch (choice) {
          case '1':
           await _handleAddTask();
           break;

          case '2':
            await _handleListTasks();
            break;

          case '3':
            await _handleToggleTask();
            break;

          case '4':
            await _handleDeleteTask();
            break;

          case '5':
            running = false;
            print("\nBye.");
            break;

          default:
            print("\nChoix invalide, veuillez réessayer.");
        }
      } catch (e) {
        print("\n $e");
      }

      if (running) {
        stdout.write("\nAppuyer sur Entrée pour continuer...");
        stdin.readLineSync();
      }
    }
  }

  void _printHeader() {
    print("\n=================================");
    print("    GESTIONNAIRE DE TÂCHES CLI   ");
    print("=================================");
  }

  Future<void> _handleAddTask() async {
    stdout.write("\nTitre de la tâche : ");
    final title = stdin.readLineSync()?.trim() ?? '';
    if (title.isEmpty) throw InvalidTaskDataException("Le titre ne peut pas être vide.");

    print("Priorité : 1. Basse | 2. Moyenne | 3. Haute");
    stdout.write("Choix (1-3, défaut = 2) : ");
    final prioInput = stdin.readLineSync()?.trim();

    Priority priority = Priority.medium;
    if (prioInput == '1') priority = Priority.low;
    if (prioInput == '3') priority = Priority.high;

    stdout.write("Est-ce une tâche urgente avec date limite ? (o/N) : ");
    final isUrgent = stdin.readLineSync()?.trim() == 'o';

    if (isUrgent) {
      stdout.write("Date limite (format AAAA-MM-JJ, ex: 2026-12-31) : ");
      final dateStr = stdin.readLineSync()?.trim() ?? '';
      try {
        final deadline = DateTime.parse(dateStr);
        await _service.addUrgentTask(title, priority, deadline);
        print("Tâche urgente ajoutée avec succès !");
      } catch (_) {
        throw InvalidTaskDataException("Format de date invalide (utiliser AAAA-MM-JJ).");
      }
    } else {
      await _service.addSimpleTask(title, priority);
      print("Tâche ajoutée avec succès !");
    }
  }

  Future<void> _handleListTasks() async {
    print("\nOption de tri :");
    print("1. Aucun tri");
    print("2. Trier par paiorité (Haute à Basse)");
    print("3. Trier par date limite");
    stdout.write("Choix (1-3) : ");
    final sortChoice = stdin.readLineSync()?.trim();

    SortOption sort = SortOption.none;
    if (sortChoice == '2') sort = SortOption.byPriority;
    if (sortChoice == '3') sort = SortOption.byDate;

    final tasks = await _service.getTasks(sortBy: sort);

    if (tasks.isEmpty) {
      print("\nAucune tâche enregistrée");
      return;
    }

    print("\n--- Liste des tâches ---");
    for (var task in tasks) {
      print("[ID: ${task.id}] ${task.getSummary()}");
    }
  }

  Future<void> _handleToggleTask() async {
    stdout.write("\nEntrez l'ID de la tâche à modifier : ");
    final id = stdin.readLineSync()?.trim() ?? '';
    await _service.toggleTaskStatus(id);
    print("Statut de la tâche mis à jour !");
  }

  Future<void> _handleDeleteTask() async {
    stdout.write("\nEntrez l’ID de la tâche à supprimer : ");
    final id = stdin.readLineSync()?.trim() ?? '';
    await _service.deleteTask(id);
    print("Tache supprimée avec succès");
  }
}