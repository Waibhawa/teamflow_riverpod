import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/providers.dart';
import '../../domain/entities/user.dart';

class UserDetailNotifier extends FamilyAsyncNotifier<User, int> {
  @override
  Future<User> build(int arg) =>
      ref.read(getUserDetailUseCaseProvider).call(arg);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getUserDetailUseCaseProvider).call(arg),
    );
  }
}

final userDetailProvider =
    AsyncNotifierProviderFamily<UserDetailNotifier, User, int>(
  UserDetailNotifier.new,
);