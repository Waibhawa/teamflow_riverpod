import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectsUseCase {
  const GetProjectsUseCase(this._repository);
  final ProjectRepository _repository;

  Future<List<Project>> call() => _repository.getProjects();
}

class GetProjectDetailUseCase {
  const GetProjectDetailUseCase(this._repository);
  final ProjectRepository _repository;

  Future<Project> call(int id) => _repository.getProjectById(id);
}
