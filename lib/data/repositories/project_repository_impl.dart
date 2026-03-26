import '../../core/error/app_exception.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/remote/project_remote_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl(this._dataSource);
  final ProjectRemoteDataSource _dataSource;

  @override
  Future<List<Project>> getProjects() async {
    try {
      final models = await _dataSource.getProjects();
      return models.map((m) => m.toEntity()).toList();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException();
    }
  }

  @override
  Future<Project> getProjectById(int id) async {
    try {
      final model = await _dataSource.getProjectById(id.toString());
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException();
    }
  }
}
