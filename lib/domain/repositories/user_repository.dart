import '../entities/user.dart';

abstract interface class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
}
