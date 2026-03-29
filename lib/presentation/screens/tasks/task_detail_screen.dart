import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/task.dart';
import '../../state/task_detail_notifier.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/task/priority_badge.dart';
import '../../widgets/task/status_chip.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});
  final int taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskDetailProvider(taskId));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Task Detail',
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
          onRetry: () => ref.read(taskDetailProvider(taskId).notifier).refresh(),
        ),
        data: (task) => _TaskDetailBody(task: task),
      ),
    );
  }
}

class _TaskDetailBody extends StatelessWidget {
  const _TaskDetailBody({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(task.title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),

        Wrap(spacing: 10, runSpacing: 8, children: [
          PriorityBadge(priority: task.priority),
          StatusChip(status: task.status),
        ]),
        const SizedBox(height: 16),

        _MetaRow(task: task),
        const SizedBox(height: 20),

        if (task.description.isNotEmpty) ...[
          Text('Description', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(task.description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
          const SizedBox(height: 20),
        ],

        if (task.tags.isNotEmpty) ...[
          Text('Labels', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 6,
            children: task.tags.map((t) => Chip(
              label: Text(t, style: const TextStyle(fontSize: 12)),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            )).toList()),
          const SizedBox(height: 20),
        ],

        _CountsRow(task: task),
        const SizedBox(height: 24),

        if (task.subTasks.isNotEmpty) ...[
          Text('Sub-tasks (${task.subTasks.length})',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...task.subTasks.map((st) => CheckboxListTile(
            dense: true,
            value: st.completed,
            onChanged: null,
            title: Text(st.title,
                style: TextStyle(
                  decoration: st.completed ? TextDecoration.lineThrough : null,
                  color: st.completed
                      ? theme.colorScheme.onSurface.withOpacity(0.45)
                      : null,
                )),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          )),
        ],
      ]),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.task});
  final Task task;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isOverdue = DateFormatter.isOverdue(task.dueDate) && task.status != TaskStatus.done;
    return Wrap(spacing: 16, runSpacing: 8, children: [
      _MetaChip(icon: Icons.calendar_today_rounded,
          label: DateFormatter.format(task.dueDate),
          color: isOverdue ? cs.error : cs.onSurface.withOpacity(0.55)),
    ]);
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 5),
      Text(label, style: TextStyle(fontSize: 13, color: color)),
    ]);
  }
}

class _CountsRow extends StatelessWidget {
  const _CountsRow({required this.task});
  final Task task;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        _CountItem(icon: Icons.comment_rounded, count: task.commentCount, label: 'Comments'),
        const SizedBox(width: 24),
        _CountItem(icon: Icons.attach_file_rounded, count: task.attachmentCount, label: 'Attachments'),
      ]),
    );
  }
}

class _CountItem extends StatelessWidget {
  const _CountItem({required this.icon, required this.count, required this.label});
  final IconData icon;
  final int count;
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.55)),
      const SizedBox(width: 6),
      Text('$count $label', style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7))),
    ]);
  }
}