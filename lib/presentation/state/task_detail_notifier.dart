import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/providers.dart';
import '../../domain/entities/task.dart';

/// Family notifier — one instance per task id.
/// Access via: ref.watch(taskDetailProvider(taskId))
class TaskDetailNotifier extends FamilyAsyncNotifier<Task, int> {
  @override
  Future<Task> build(int arg) =>
      ref.read(getTaskDetailUseCaseProvider).call(arg);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getTaskDetailUseCaseProvider).call(arg),
    );
  }
}

final taskDetailProvider =
    AsyncNotifierProviderFamily<TaskDetailNotifier, Task, int>(
  TaskDetailNotifier.new,
);
