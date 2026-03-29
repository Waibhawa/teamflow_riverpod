import 'sub_task.dart';

enum TaskPriority {
  critical,
  high,
  medium,
  low;

  static TaskPriority fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'critical': return TaskPriority.critical;
      case 'high':     return TaskPriority.high;
      case 'low':      return TaskPriority.low;
      default:         return TaskPriority.medium;
    }
  }

  String get displayLabel {
    switch (this) {
      case TaskPriority.critical: return 'Critical';
      case TaskPriority.high:     return 'High';
      case TaskPriority.medium:   return 'Medium';
      case TaskPriority.low:      return 'Low';
    }
  }
}

enum TaskStatus {
  open,
  inProgress,
  done;

  static TaskStatus fromString(String? value) {
    switch (value) {
      case 'in_progress': return TaskStatus.inProgress;
      case 'done':        return TaskStatus.done;
      default:            return TaskStatus.open;
    }
  }

  String get displayLabel {
    switch (this) {
      case TaskStatus.open:       return 'Open';
      case TaskStatus.inProgress: return 'In Progress';
      case TaskStatus.done:       return 'Done';
    }
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.tags,
    required this.commentCount,
    required this.attachmentCount,
    required this.subTasks,
    this.dueDate,
    this.assigneeId,
    this.projectId,
  });

  final int id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final String? dueDate;
  final List<String> tags;
  final int? assigneeId;
  final int? projectId;
  final int commentCount;
  final int attachmentCount;
  final List<SubTask> subTasks;

  Task copyWith({
    int? id, String? title, String? description,
    TaskPriority? priority, TaskStatus? status,
    String? dueDate, List<String>? tags,
    int? assigneeId, int? projectId,
    int? commentCount, int? attachmentCount,
    List<SubTask>? subTasks,
  }) => Task(
    id: id ?? this.id, title: title ?? this.title,
    description: description ?? this.description,
    priority: priority ?? this.priority, status: status ?? this.status,
    dueDate: dueDate ?? this.dueDate, tags: tags ?? this.tags,
    assigneeId: assigneeId ?? this.assigneeId, projectId: projectId ?? this.projectId,
    commentCount: commentCount ?? this.commentCount,
    attachmentCount: attachmentCount ?? this.attachmentCount,
    subTasks: subTasks ?? this.subTasks,
  );
}
