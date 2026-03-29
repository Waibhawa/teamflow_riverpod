import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Returns the full list of tasks from the repository.
///
/// Use cases are the single entry-point that Notifiers should call.
/// They exist so business rules can be added here later without
/// touching either the UI or the data layer.
class GetTasksUseCase {
  const GetTasksUseCase(this._repository);
  final TaskRepository _repository;

  Future<List<Task>> call() => _repository.getTasks();
}
