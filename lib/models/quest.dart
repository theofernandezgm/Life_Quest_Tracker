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
}
