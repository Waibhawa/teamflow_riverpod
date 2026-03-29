import 'package:flutter/material.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/entities/user.dart';
import 'priority_badge.dart';
import 'status_chip.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.assignee, this.onTap});
  final Task task;
  final User? assignee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = DateFormatter.isOverdue(task.dueDate) && task.status != TaskStatus.done;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.6))),
      child: InkWell(borderRadius: BorderRadius.circular(12), onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              PriorityBadge(priority: task.priority),
              const SizedBox(width: 8),
              StatusChip(status: task.status),
              const Spacer(),
              if (assignee != null) _AvatarBubble(user: assignee!),
            ]),
            const SizedBox(height: 10),
            Text(task.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.calendar_today_rounded, size: 13,
                  color: isOverdue ? theme.colorScheme.error
                      : theme.colorScheme.onSurface.withOpacity(0.45)),
              const SizedBox(width: 4),
              Text(DateFormatter.format(task.dueDate, short: true),
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: isOverdue ? theme.colorScheme.error
                          : theme.colorScheme.onSurface.withOpacity(0.55),
                      fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal)),
              const SizedBox(width: 10),
              Expanded(child: _TagRow(tags: task.tags)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: user.name,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ClipOval(
          child: user.avatarUrl != null
              ? SvgPicture.network(
                  user.avatarUrl!,
                  width: 28,
                  height: 28,
                  placeholderBuilder: (_) => Text(
                    user.initials,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                )
              : Text(
                  user.initials,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tags});
  final List<String> tags;
  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: Row(children: tags.take(3).map((t) => Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(color: cs.secondaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20)),
          child: Text(t, style: TextStyle(fontSize: 11, color: cs.onSecondaryContainer)),
        ))).toList()));
  }
}
