import 'package:mongo_dart/mongo_dart.dart';

class Quest {
  ObjectId id; // Use ObjectId for MongoDB
  String title;
  String description;
  String type;
  String dueDate;
  bool isCompleted;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Convert a Quest object into a Map for MongoDB
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'type': type,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  // Create a Quest object from a MongoDB map
  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['_id'], // MongoDB uses _id
      title: map['title'],
      description: map['description'],
      type: map['type'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'],
    );
  }
}