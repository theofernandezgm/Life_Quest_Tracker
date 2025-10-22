import 'package:mongo_dart/mongo_dart.dart';
import 'package:quest_tracker/db_config.dart'; // Import your config file
import 'package:quest_tracker/models/quest.dart';

class MongoDatabase {
  static var db;
  static var questCollection;

  static connect() async {
    try {
      db = await Db.create(MONGO_CONNECTION_STRING);
      await db.open();
      questCollection = db.collection('quests'); // Your collection name
      print('MongoDB Connected!');
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    }
  }

  static Future<List<Quest>> getQuests() async {
    if (db == null || !db.isConnected) {
      await connect();
    }
    try {
      final quests = await questCollection.find().toList();
      return quests.map((q) => Quest.fromMap(q)).toList();
    } catch (e) {
      print('Error fetching quests: $e');
      return [];
    }
  }

  static Future<void> addQuest(
      String title, String description, String type, String dueDate) async {
    if (db == null || !db.isConnected) {
      await connect();
    }
    try {
      // Create a new quest map. MongoDB will generate the _id.
      final newQuest = {
        'title': title,
        'description': description,
        'type': type,
        'dueDate': dueDate,
        'isCompleted': false, // Default value
      };
      await questCollection.insertOne(newQuest);
    } catch (e) {
      print('Error adding quest: $e');
    }
  }

  static Future<void> updateQuest(Quest quest) async {
    if (db == null || !db.isConnected) {
      await connect();
    }
    try {
      // Find quest by its _id and update it
      await questCollection.update(
        where.eq('_id', quest.id), // Use the quest's ObjectId
        quest.toMap(), // Send the full updated quest map
      );
    } catch (e) {
      print('Error updating quest: $e');
    }
  }

  static Future<void> deleteQuest(ObjectId id) async {
    if (db == null || !db.isConnected) {
      await connect();
    }
    try {
      await questCollection.remove(where.eq('_id', id));
    } catch (e) {
      print('Error deleting quest: $e');
    }
  }
}