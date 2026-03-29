import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../models/task_model.dart';

abstract interface class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  const TaskRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await _dio.getOrThrow<Map<String, dynamic>>(ApiConstants.tasks);
    final data = response.data;
    if (data == null) return [];
    final raw = data['tasks'];
    if (raw is! List) return [];
    return raw.whereType<Map<String, dynamic>>().map(TaskModel.fromJson).toList();
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    final response = await _dio.getOrThrow<Map<String, dynamic>>('${ApiConstants.tasks}/$id');
    final data = response.data;
    if (data == null) throw const NotFoundException();
    final raw = data['task'];
    if (raw is! Map<String, dynamic>) throw const ParseException();
    return TaskModel.fromJson(raw);
  }
}
