import 'package:flutter/material.dart';
import '../../../domain/entities/project.dart';
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.onTap});
  final Project project;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = _hexColor(project.color);
    final pct = (project.progress * 100).round();
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.6))),
      child: InkWell(borderRadius: BorderRadius.circular(12), onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 14, height: 14,
                  decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Expanded(child: Text(project.name, overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
              Text('$pct%', style: theme.textTheme.labelMedium?.copyWith(
                  color: accentColor, fontWeight: FontWeight.w700)),
            ]),
            if (project.description != null) ...[
              const SizedBox(height: 6),
              Text(project.description!, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.55))),
            ],
            const SizedBox(height: 12),
            ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: project.progress, minHeight: 6,
                  backgroundColor: accentColor.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor))),
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.task_alt_rounded, size: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text('${project.taskCount} tasks',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.55))),
              const SizedBox(width: 14),
              Icon(Icons.people_rounded, size: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text('${project.memberCount} members',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.55))),
            ]),
          ])),
      ),
    );
  }
  Color _hexColor(String hex) {
    try { return Color(int.parse(hex.replaceFirst('#', '0xFF'))); }
    catch (_) { return const Color(0xFF6C63FF); }
  }
}
