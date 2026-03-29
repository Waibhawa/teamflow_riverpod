import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../domain/entities/user.dart';
import '../../state/user_detail_notifier.dart';
import '../../widgets/common/app_error_widget.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userDetailProvider(userId));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Team Member',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        elevation: 0,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e is AppException ? e.message : e.toString(),
          onRetry: () => ref.read(userDetailProvider(userId).notifier).refresh(),
        ),
        data: (user) => _UserDetailBody(user: user),
      ),
    );
  }
}

class _UserDetailBody extends StatelessWidget {
  const _UserDetailBody({required this.user});
  final User user;
  String _formatDate(String iso) {
  try {
    final date = DateTime.parse(iso).toLocal();
    return '${date.day}/${date.month}/${date.year}';
  } catch (_) {
    return iso;
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          // Avatar
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFF6C63FF).withOpacity(0.15),
            child: Text(
              user.initials,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6C63FF),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            user.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),

          // Role
          Text(
            user.role,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 8),

          // Online badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: user.isOnline
                  ? const Color(0xFFDCFCE7)
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: user.isOnline
                    ? const Color(0xFF166534)
                    : theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Info cards
          if (user.email != null)
            _InfoRow(
              icon: Icons.email_rounded,
              label: 'Email',
              value: user.email!,
            ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.work_rounded,
            label: 'Role',
            value: user.role,
          ),
          const SizedBox(height: 12),
if (user.taskCount != null)
  _InfoRow(
    icon: Icons.task_alt_rounded,
    label: 'Tasks assigned',
    value: '${user.taskCount}',
  ),
const SizedBox(height: 12),
if (user.joinedAt != null)
  _InfoRow(
    icon: Icons.calendar_month_rounded,
    label: 'Joined',
    value: _formatDate(user.joinedAt!),
  ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.6),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5))),
          const SizedBox(height: 2),
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ]),
      ]),
    );
  }
}