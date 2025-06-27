class Todo {
  final int id;
  final String userId;
  final String taskName;
  final String? description;
  final String? category;
  final DateTime dueDate;
  bool isCompleted;
  final DateTime createdAt;
  final isArchived;
  final DateTime? deletedAt;

  Todo({
    required this.id,
    required this.userId,
    required this.taskName,
    this.description,
    this.category,
    required this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
    this.isArchived = false,
    this.deletedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userId: json['user_id'],
      taskName: json['task_name'],
      description: json['description'],
      category: json['category'],
      dueDate: DateTime.parse(json['due_date']),
      isCompleted: json['is_completed'],
      createdAt: DateTime.parse(json['created_at']),
      isArchived: json['is_archived'] ?? false,
      deletedAt: json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'task_name': taskName,
      'description': description,
      'category': category,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'is_archived': isArchived,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
