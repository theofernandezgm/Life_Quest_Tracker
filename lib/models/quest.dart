class Quest {
  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime dueDate;
  final bool isCompleted;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.dueDate,
    this.isCompleted = false,
  });
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'type': type,
      'dueDate': dueDate.toString(),
      'isCompleted': isCompleted,
    };
  }
  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}