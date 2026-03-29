import '../../core/error/app_exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._dataSource);
  final UserRemoteDataSource _dataSource;

  @override
  Future<List<User>> getUsers() async {
    try {
      final models = await _dataSource.getUsers();
      return models.map((m) => m.toEntity()).toList();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException();
    }
  }

  @override
  Future<User> getUserById(int id) async {
    try {
      final model = await _dataSource.getUserById(id);
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException();
    }
  }
}
