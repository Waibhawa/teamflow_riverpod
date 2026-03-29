import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/tasks/task_list_screen.dart';
import '../screens/tasks/task_detail_screen.dart';
import '../screens/projects/projects_screen.dart';
import '../screens/projects/project_detail_screen.dart';
import '../screens/team/team_screen.dart';
import '../screens/team/user_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/tasks',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _ScaffoldWithBottomNav(child: child),
      routes: [
        GoRoute(path: '/tasks',    builder: (_, __) => const TaskListScreen()),
        GoRoute(path: '/projects', builder: (_, __) => const ProjectsScreen()),
        GoRoute(path: '/team',     builder: (_, __) => const TeamScreen()),
      ],
    ),
    GoRoute(
      path: '/tasks/:id',
      builder: (_, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return TaskDetailScreen(taskId: id);
      },
    ),
    GoRoute(
      path: '/projects/:id',
      builder: (_, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return ProjectDetailScreen(projectId: id);
      },
    ),
    GoRoute(
      path: '/users/:id',
      builder: (_, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return UserDetailScreen(userId: id);
     },),
  ],
);

const _kBarColor     = Color(0xFF8B84FF);
const _kActiveColor  = Color(0xFF2D2580);
const _kIconActive   = Color(0xFFA8FF78);
const _kIconInactive = Colors.white;
const _kLabelColor   = Colors.white;


class _ScaffoldWithBottomNav extends StatelessWidget {
  const _ScaffoldWithBottomNav({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = switch (location) {
      String l when l.startsWith('/projects') => 1,
      String l when l.startsWith('/team')     => 2,
      _                                        => 0,
    };

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
        bottomNavigationBar: _PillNavBar(
          currentIndex: currentIndex,
          onTap: (i) {
            switch (i) {
              case 0: context.go('/tasks');
              case 1: context.go('/projects');
              case 2: context.go('/team');
            }
          },
        ),
      ),
    );
  }
}


class _PillNavBar extends StatelessWidget {
  const _PillNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    _TabItem(icon: Icons.list_alt, label: 'TASKS'),
    _TabItem(icon: Icons.format_list_bulleted_sharp, label: 'PROJECTS'),
    _TabItem(icon: Icons.people_rounded, label: 'TEAM'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: _kBarColor,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: i == currentIndex
                      ? _ActiveTab(tab: _tabs[i])
                      : _InactiveTab(tab: _tabs[i]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}


class _ActiveTab extends StatelessWidget {
  const _ActiveTab({required this.tab});
  final _TabItem tab;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kActiveColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tab.icon, color: const Color.fromARGB(255, 242, 244, 240), size: 28),
          const SizedBox(width: 8),
          Text(
            tab.label,
            style: const TextStyle(
              color: _kLabelColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}


class _InactiveTab extends StatelessWidget {
  const _InactiveTab({required this.tab});
  final _TabItem tab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(tab.icon, color: _kIconInactive, size: 24),
    );
  }
}


class _TabItem {
  const _TabItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}