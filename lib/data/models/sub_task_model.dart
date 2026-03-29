import '../../domain/entities/sub_task.dart';

class SubTaskModel {
  const SubTaskModel({
    required this.id,
    required this.title,
    required this.completed,
  });

  final String id;
  final String title;
  final bool completed;

  factory SubTaskModel.fromJson(Map<String, dynamic> json) => SubTaskModel(
        id: json['id']?.toString() ?? '0',
        title: json['title']?.toString() ?? 'Untitled', 
        completed: json['done'] == true || json['done'] == 1,
      );

  SubTask toEntity() => SubTask(
        id: int.tryParse(id) ?? id.hashCode,
        title: title,
        completed: completed,
      );
}
