import '../../domain/entities/user.dart';

/// DTO for /users and /users/:id
///
/// API notes:
///   • id is an int (unlike tasks/projects which are strings)
///   • online field is "online" (bool)
///   • /users returns a raw JSON array — no wrapper key
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.isOnline,
    this.avatarUrl,
    this.email,
    this.taskCount,
    this.joinedAt,
  });

  final int id;
  final String name;
  final String role;
  final bool isOnline;
  final String? avatarUrl;
  final String? email;
  final int? taskCount;
  final String? joinedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] is int ? json['id'] as int
            : int.tryParse(json['id']?.toString() ?? '') ?? 0,
        name: json['name']?.toString() ?? 'Unknown',
        role: json['role']?.toString() ?? '',
        isOnline: json['online'] == true,
        avatarUrl: json['avatar_url']?.toString(),
        email: json['email']?.toString(),
        taskCount: json['task_count'] as int?,    // ← add
        joinedAt: json['joined_at']?.toString(),
      );

  User toEntity() => User(
        id: id,
        name: name,
        role: role,
        isOnline: isOnline,
        avatarUrl: avatarUrl,
        email: email,
        taskCount: taskCount,
        joinedAt: joinedAt, 
      );
}
