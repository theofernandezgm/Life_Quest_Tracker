import 'package:flutter/material.dart';
import 'package:quest_tracker/screens/home_screen.dart';
import 'package:quest_tracker/services/mongo_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Connect to the database before running the app
  await MongoDatabase.connect();

  runApp(QuestTrackerApp());
}

class QuestTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quest Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}