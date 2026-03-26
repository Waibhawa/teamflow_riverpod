import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../models/project_model.dart';

abstract interface class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectById(String id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  const ProjectRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<ProjectModel>> getProjects() async {
    final response = await _dio.getOrThrow<Map<String, dynamic>>(ApiConstants.projects);
    final data = response.data;
    if (data == null) return [];
    final raw = data['projects'];
    if (raw is! List) return [];
    return raw.whereType<Map<String, dynamic>>().map(ProjectModel.fromJson).toList();
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final response = await _dio.getOrThrow<Map<String, dynamic>>('${ApiConstants.projects}/$id');
    final data = response.data;
    if (data == null) throw const NotFoundException();
    final raw = data['project'];
    if (raw is! Map<String, dynamic>) throw const ParseException();
    return ProjectModel.fromJson(raw);
  }
}
