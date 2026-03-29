import '../entities/task.dart';

/// The UI layer depends on this interface, never on the concrete
/// implementation. Swapping real → mock requires zero UI changes.
abstract interface class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> getTaskById(int id);
}
