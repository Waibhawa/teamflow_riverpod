import 'package:flutter/material.dart';
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded), label: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
