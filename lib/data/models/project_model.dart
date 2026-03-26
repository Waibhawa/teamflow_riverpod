import '../../domain/entities/project.dart';

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.color,
    required this.progress,
    required this.taskCount,
    required this.memberCount,
    this.description,
  });

  final String id;
  final String name;
  final String color;
  final double progress;
  final int taskCount;
  final int memberCount;
  final String? description;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id']?.toString() ?? '0',
        name: json['name']?.toString() ?? 'Unnamed Project',
        color: _parseColor(json['color']),
        progress: _parseProgress(json['progress']),
        taskCount: _int(json['task_count']) ?? 0,
        memberCount: _int(json['member_count']) ?? 0,
        description: json['description']?.toString(),
      );

  Project toEntity() => Project(
        id: int.tryParse(id) ?? id.hashCode,
        name: name,
        color: color,
        progress: progress,
        taskCount: taskCount,
        memberCount: memberCount,
        description: description,
      );

  static int? _int(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString());
  }

  static String _parseColor(dynamic v) {
    if (v == null) return '#6C63FF';
    final s = v.toString().trim();
    if (s.startsWith('#') && s.length >= 7) return s;
    if (RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(s)) return '#$s';
    return '#6C63FF';
  }

  static double _parseProgress(dynamic v) {
  if (v == null) return 0.0;

  final s = v.toString().replaceAll('%', '').trim();
  final d = double.tryParse(s) ?? 0.0;

  return (d / 100).clamp(0.0, 1.0);
}
}
