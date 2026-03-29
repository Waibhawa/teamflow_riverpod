import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../domain/entities/user.dart';
import '../../../presentation/state/task_list_notifier.dart';
import '../../../presentation/state/team_notifier.dart';
import '../../widgets/common/app_empty_widget.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../widgets/task/task_card.dart';
import 'package:go_router/go_router.dart';


class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskListProvider);
    final teamState = ref.watch(teamProvider);

    final userMap = teamState.valueOrNull?.fold<Map<int, User>>(
      {},
      (map, u) => map..[u.id] = u,
    ) ?? {};

    return Scaffold(
      backgroundColor: Colors.transparent,        
      appBar: AppBar(
        backgroundColor: Colors.transparent,      
        title: const Text('Tasks'),
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      body: taskState.when(
          loading: () => const ShimmerLoader(),
          error: (e, _) => AppErrorWidget(
            message: e is AppException ? e.message : e.toString(),
            onRetry: () => ref.read(taskListProvider.notifier).refresh(),
          ),
          data: (tasks) {
            if (tasks.isEmpty) {
              return const AppEmptyWidget(
                message: 'No tasks found.\nEnjoy the break!',
                icon: Icons.task_alt_rounded,
              );
            }
            return RefreshIndicator(
              onRefresh: () => ref.read(taskListProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final task = tasks[i];
                  return TaskCard(
                    task: task,
                    assignee: task.assigneeId != null ? userMap[task.assigneeId] : null,
                    onTap: () => context.push('/tasks/${task.id}'),
                  );
                },
              ),
            );
          },
        ),                                         
    );
  }
}