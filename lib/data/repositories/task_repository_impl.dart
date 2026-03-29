import '../../core/error/app_exception.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/remote/task_remote_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this._dataSource);
  final TaskRemoteDataSource _dataSource;

  @override
  Future<List<Task>> getTasks() async {
    try {
      final models = await _dataSource.getTasks();
      return models.map((m) => m.toEntity()).toList();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException();
    }
  }

  @override
  Future<Task> getTaskById(int id) async {
    try {
      final model = await _dataSource.getTaskById(id.toString());
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException();
    }
  }
}
