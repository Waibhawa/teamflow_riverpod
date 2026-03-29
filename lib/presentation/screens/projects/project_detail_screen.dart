import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../di/providers.dart';
import '../../../domain/entities/project.dart';
import '../../widgets/common/app_error_widget.dart';

final projectDetailProvider = FutureProvider.family<Project, int>((ref, id) {
  return ref.read(getProjectDetailUseCaseProvider).call(id);
});

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});
  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectDetailProvider(projectId));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Project Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
        elevation: 0,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e is AppException ? e.message : e.toString(),
          onRetry: () => ref.invalidate(projectDetailProvider(projectId)),
        ),
        data: (project) => _ProjectDetailBody(project: project),
      ),
    );
  }
}

class _ProjectDetailBody extends StatelessWidget {
  const _ProjectDetailBody({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = _hexColor(project.color);
    final pct = (project.progress * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 18, height: 18,
              decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Text(project.name,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 20),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Progress', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          Text('$pct%', style: TextStyle(color: accentColor, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: project.progress, minHeight: 10,
              backgroundColor: accentColor.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor))),
        const SizedBox(height: 24),

        if (project.description != null) ...[
          Text('About', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(project.description!,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
          const SizedBox(height: 24),
        ],

        Row(children: [
          _StatCard(icon: Icons.task_alt_rounded, label: 'Tasks', value: '${project.taskCount}', color: accentColor),
          const SizedBox(width: 12),
          _StatCard(icon: Icons.people_rounded, label: 'Members', value: '${project.memberCount}', color: accentColor),
        ]),
      ]),
    );
  }

  Color _hexColor(String hex) {
    try { return Color(int.parse(hex.replaceFirst('#', '0xFF'))); }
    catch (_) { return const Color(0xFF6C63FF); }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700, color: color)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.55))),
        ]),
      ),
    );
  }
}