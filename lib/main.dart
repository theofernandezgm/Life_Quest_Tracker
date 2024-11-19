import 'package:flutter/material.dart';
import 'package:quest_tracker_app/screens/home_screen.dart';


void main() {
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
