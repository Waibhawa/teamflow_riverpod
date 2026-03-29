import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/error/app_exception.dart';
import '../../state/team_notifier.dart';
import '../../widgets/common/app_empty_widget.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../widgets/team/member_card.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teamProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Team'),
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      body: state.when(
        loading: () => const ShimmerLoader(itemCount: 4),
        error: (e, _) => AppErrorWidget(
          message: e is AppException ? e.message : e.toString(),
          onRetry: () => ref.read(teamProvider.notifier).refresh(),
        ),
        data: (users) {
          if (users.isEmpty) {
            return const AppEmptyWidget(message: 'No team members found.', icon: Icons.people_outline_rounded);
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(teamProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => MemberCard(
                user: users[i],
                onTap: () => context.push('/users/${users[i].id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}