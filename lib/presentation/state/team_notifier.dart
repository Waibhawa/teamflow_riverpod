import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/providers.dart';
import '../../domain/entities/user.dart';

class TeamNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() => _fetch();

  Future<List<User>> _fetch() =>
      ref.read(getUsersUseCaseProvider).call();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final teamProvider =
    AsyncNotifierProvider<TeamNotifier, List<User>>(TeamNotifier.new);
