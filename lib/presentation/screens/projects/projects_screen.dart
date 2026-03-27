import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/error/app_exception.dart';
import '../../state/projects_notifier.dart';
import '../../widgets/common/app_empty_widget.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../widgets/project/project_card.dart'; 

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectsProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,           
      appBar: AppBar(
        backgroundColor: Colors.transparent,         
        title: const Text('Projects'),
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      body: state.when(
          loading: () => const ShimmerLoader(itemCount: 4),
          error: (e, _) => AppErrorWidget(
            message: e is AppException ? e.message : e.toString(),
            onRetry: () => ref.read(projectsProvider.notifier).refresh(),
          ),
          data: (projects) {
            if (projects.isEmpty) {
              return const AppEmptyWidget(message: 'No projects yet.', icon: Icons.folder_open_rounded);
            }
            return RefreshIndicator(
              onRefresh: () => ref.read(projectsProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => ProjectCard(
                  project: projects[i],
                  onTap: () => context.push('/projects/${projects[i].id}'),
                ),
              ),
            );
          },
        ),
    );
  }
}