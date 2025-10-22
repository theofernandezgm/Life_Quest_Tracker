// lib/main.dart
import 'package:flutter/material.dart';
import 'package:quest_tracker/screens/home_screen.dart';
import 'package:quest_tracker/services/local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the local DB for the demo
  await LocalDatabase().init();

  runApp(QuestTrackerApp());
}

class QuestTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Quest Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomeScreen(),
    );
  }
}
