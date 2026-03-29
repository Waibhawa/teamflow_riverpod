class SubTask {
  const SubTask({
    required this.id,
    required this.title,
    required this.completed,
  });

  final int id;
  final String title;
  final bool completed;

  SubTask copyWith({int? id, String? title, bool? completed}) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
