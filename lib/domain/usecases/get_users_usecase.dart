import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._repository);
  final UserRepository _repository;

  Future<List<User>> call() => _repository.getUsers();
}
