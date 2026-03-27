import 'package:flutter/material.dart';
class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({super.key, required this.message, this.icon});
  final String message;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.inbox_rounded, size: 56,
                color: theme.colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5))),
          ],
        ),
      ),
    );
  }
}
