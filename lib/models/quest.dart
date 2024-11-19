class Quest {
  String id;
  String title;
  String description;
  String type;
  String dueDate;
  bool isCompleted; // Removed final keyword

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.dueDate,
    this.isCompleted = false,
  });
}
