import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<UserModel>> getUsers() async {
    // /users returns a raw JSON array with no wrapper key
    final response = await _dio.getOrThrow<dynamic>(ApiConstants.users);
    final data = response.data;
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(UserModel.fromJson).toList();
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final response = await _dio.getOrThrow<Map<String, dynamic>>('${ApiConstants.users}/$id');
    final data = response.data;
    if (data == null) throw const NotFoundException();
    return UserModel.fromJson(data);
  }
}
