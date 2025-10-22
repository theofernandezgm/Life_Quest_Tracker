// lib/models/quest.dart
class Quest {
  /// id is stored as a string (we use the record key from the DB as a string)
  String? id;
  String title;
  String description;
  String type;
  String dueDate;
  bool isCompleted;

  Quest({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map, {String? id}) {
    return Quest(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      dueDate: map['dueDate'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
