import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart';
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});
  final TaskPriority priority;
  @override
  Widget build(BuildContext context) {
    final (color, bg) = _colors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(priority.displayLabel,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
              color: color, letterSpacing: 0.3)),
    );
  }
  (Color, Color) _colors(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (priority) {
      case TaskPriority.critical: return (cs.onErrorContainer, cs.errorContainer);
      case TaskPriority.high:     return (const Color(0xFF92400E), const Color(0xFFFEF3C7));
      case TaskPriority.medium:   return (const Color(0xFF1E40AF), const Color(0xFFDBEAFE));
      case TaskPriority.low:      return (const Color(0xFF166534), const Color(0xFFDCFCE7));
    }
  }
}
