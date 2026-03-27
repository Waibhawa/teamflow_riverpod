import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/providers.dart';
import '../../domain/entities/project.dart';

class ProjectsNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() => _fetch();

  Future<List<Project>> _fetch() =>
      ref.read(getProjectsUseCaseProvider).call();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final projectsProvider =
    AsyncNotifierProvider<ProjectsNotifier, List<Project>>(ProjectsNotifier.new);
