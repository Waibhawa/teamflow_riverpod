import '../../domain/entities/task.dart';
import '../../domain/entities/sub_task.dart';
import 'sub_task_model.dart';

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.statusCode,
    required this.tags,
    required this.commentCount,
    required this.attachmentCount,
    required this.subTasks,
    this.dueDate,
    this.assigneeId,
    this.projectId,
  });

  final String id;
  final String title;
  final String description;
  final String priority;
  final String statusCode;
  final String? dueDate;
  final List<String> tags;
  final String? assigneeId;
  final String? projectId;
  final int commentCount;
  final int attachmentCount;
  final List<SubTaskModel> subTasks;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final statusRaw = json['status'];
    final statusCode = statusRaw is Map
        ? statusRaw['code']?.toString() ?? 'open'
        : statusRaw?.toString() ?? 'open';

    final dueDate = _str(json['due_date']) ??
        _str((json['meta'] as Map?)?['due']);

    return TaskModel(
      id: json['id']?.toString() ?? '0',
      title: _str(json['title']) ?? 'Untitled',
      description: _str(json['description']) ?? '',
      priority: _str(json['priority']) ?? 'medium',
      statusCode: statusCode,
      dueDate: dueDate,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      assigneeId: json['assignee_id']?.toString(),
      projectId: json['project_id']?.toString(),
      commentCount: _int(json['comment_count']) ?? 0,
      attachmentCount: _int(json['attachment_count']) ?? 0,
      subTasks: _parseSubTasks(json['sub_tasks']),
      
    );
  }

  Task toEntity() => Task(
        id: int.tryParse(id) ?? id.hashCode,
        title: title,
        description: description,
        priority: TaskPriority.fromString(priority),
        status: TaskStatus.fromString(statusCode),
        dueDate: dueDate,
        tags: tags,
        assigneeId: assigneeId != null ? int.tryParse(assigneeId!) : null,
        projectId: projectId != null ? int.tryParse(projectId!) : null,
        commentCount: commentCount,
        attachmentCount: attachmentCount,
        subTasks: subTasks.map((s) => s.toEntity()).toList(),
      );

  static int? _int(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString());
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static List<String> _parseLabels(dynamic v) {
    if (v is! List) return [];
    return v
        .whereType<Map>()
        .map((e) => e['name']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static List<SubTaskModel> _parseSubTasks(dynamic v) {
    if (v is! List) return [];
    return v
        .whereType<Map<String, dynamic>>()
        .map(SubTaskModel.fromJson)
        .toList();
  }
}
