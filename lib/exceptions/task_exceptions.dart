class TaskNotFoundException implements Exception {
  final String id;
  TaskNotFoundException(this.id);

  @override
  String toString() {
    return "Erreur : La tâche avec l'ID '$id' n'a pas été trouvée.";
  }
}

class InvalidTaskDataException implements Exception {
  final String message;
  InvalidTaskDataException(this.message);

  @override
  String toString() {
    return "Erreur de données : $message";
  }
}