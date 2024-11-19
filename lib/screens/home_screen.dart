import 'package:flutter/material.dart';
import 'package:quest_tracker/models/quest.dart';
import 'package:quest_tracker/widgets/quest_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Quest> quests = []; // In-memory list of quests

  // Text controllers for input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  // Add a new quest
  void _addQuest() {
    if (titleController.text.isNotEmpty) {
      setState(() {
        quests.add(Quest(
          title: titleController.text,
          description: descriptionController.text,
          id: idController.text,
          type: typeController.text,
          dueDate: dueDateController.text,
          isCompleted: false, // Default value
        ));
      });
      // Clear input fields
      titleController.clear();
      descriptionController.clear();
      idController.clear();
      typeController.clear();
      dueDateController.clear();

      // Close the dialog
      Navigator.of(context).pop();
    }
  }

  // Show a dialog to add a quest
  void _showAddQuestDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add a Quest'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: dueDateController,
                decoration: InputDecoration(labelText: 'Due Date'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addQuest,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quest Tracker'),
      ),
      body: QuestList(
        quests: quests,
        onToggleComplete: (index) {
          setState(() {
            quests[index].isCompleted = !quests[index].isCompleted;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddQuestDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
