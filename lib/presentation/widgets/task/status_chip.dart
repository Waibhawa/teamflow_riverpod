import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart';
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final TaskStatus status;
  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _config();
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    ]);
  }
  (String, Color, IconData) _config() {
    switch (status) {
      case TaskStatus.open:       return ('Open', const Color(0xFF6B7280), Icons.radio_button_unchecked);
      case TaskStatus.inProgress: return ('In Progress', const Color(0xFF2563EB), Icons.timelapse_rounded);
      case TaskStatus.done:       return ('Done', const Color(0xFF16A34A), Icons.check_circle_rounded);
    }
  }
}
