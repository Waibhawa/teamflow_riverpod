class Project {
  const Project({
    required this.id,
    required this.name,
    required this.color,
    required this.progress,
    required this.taskCount,
    required this.memberCount,
    this.description,
  });

  final int id;
  final String name;

  /// Hex color string (e.g. '#4A90D9') for the project's accent.
  final String color;

  /// Progress value between 0.0 and 1.0.
  final double progress;

  final int taskCount;
  final int memberCount;
  final String? description;

  Project copyWith({
    int? id,
    String? name,
    String? color,
    double? progress,
    int? taskCount,
    int? memberCount,
    String? description,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      progress: progress ?? this.progress,
      taskCount: taskCount ?? this.taskCount,
      memberCount: memberCount ?? this.memberCount,
      description: description ?? this.description,
    );
  }
}
