import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTaskDetailUseCase {
  const GetTaskDetailUseCase(this._repository);
  final TaskRepository _repository;

  Future<Task> call(int id) => _repository.getTaskById(id);
}
