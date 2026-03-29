class User {
  const User({
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

  User copyWith({
    int? id,
    String? name,
    String? role,
    bool? isOnline,
    String? avatarUrl,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      isOnline: isOnline ?? this.isOnline,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
    );
  }

  /// Returns initials (up to 2 chars) for the avatar fallback.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
