class Task {
  int? id;
  String title;
  String? description;
  DateTime? dueDate;
  String priority;
  String? subject;
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    this.subject,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a Task object into a Map object for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'subject': subject,
      'isCompleted': isCompleted ? 1 : 0, // Store bool as int
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Extract a Task object from a Map object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'],
      subject: map['subject'],
      isCompleted: map['isCompleted'] == 1, // Read int as bool
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? subject,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      subject: subject ?? this.subject,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
