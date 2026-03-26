import '../entities/project.dart';

abstract interface class ProjectRepository {
  Future<List<Project>> getProjects();
  Future<Project> getProjectById(int id);
}
