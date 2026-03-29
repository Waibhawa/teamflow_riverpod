import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.user, this.onTap}); // ← added onTap
  final User user;
  final VoidCallback? onTap; // ← added

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.6))),
      child: InkWell(                                   
        borderRadius: BorderRadius.circular(12),        
        onTap: onTap,                                   
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(children: [
            Stack(children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: ClipOval(
                  child: user.avatarUrl != null
                      ? SvgPicture.network(
                          user.avatarUrl!,
                          width: 44,
                          height: 44,
                          placeholderBuilder: (_) => Text(
                            user.initials,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )
                      : Text(
                          user.initials,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                        color: user.isOnline
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF9CA3AF),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.colorScheme.surface, width: 2))),
              ),
            ]),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(user.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(user.role,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.55))),
                ])),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: user.isOnline
                        ? const Color(0xFFDCFCE7)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(user.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: user.isOnline
                            ? const Color(0xFF166534)
                            : theme.colorScheme.onSurface.withOpacity(0.5)))),
          ]),
        ),
      ),                                      
    );
  }
}