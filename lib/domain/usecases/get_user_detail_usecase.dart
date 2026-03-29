import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserDetailUseCase {
  const GetUserDetailUseCase(this._repository);
  final UserRepository _repository;

  Future<User> call(int id) => _repository.getUserById(id);
}