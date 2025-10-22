import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:quest_tracker/models/quest.dart';
import 'package:quest_tracker/services/mongo_service.dart';
import 'package:quest_tracker/widgets/quest_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use a Future to handle loading state
  late Future<List<Quest>> _questsFuture;

  @override
  void initState() {
    super.initState();
    _fetchQuests();
  }

  // Fetch quests from the database
  void _fetchQuests() {
    setState(() {
      _questsFuture = MongoDatabase.getQuests();
    });
  }

  // Add a new quest to the database
  void _addQuest(String title, String description, String type, String dueDate) async {
    await MongoDatabase.addQuest(title, description, type, dueDate);
    _fetchQuests(); // Refresh the list
    Navigator.of(context).pop(); // Close the dialog
  }

  // Update an existing quest
  void _updateQuest(Quest quest) async {
    await MongoDatabase.updateQuest(quest);
    _fetchQuests(); // Refresh the list
    Navigator.of(context).pop(); // Close the dialog
  }

  // Delete a quest
  void _deleteQuest(mongo.ObjectId id) async {
    // Show confirmation dialog
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to delete this quest?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await MongoDatabase.deleteQuest(id);
      _fetchQuests(); // Refresh the list
    }
  }

  // Toggle quest completion status
  void _toggleComplete(Quest quest) async {
    quest.isCompleted = !quest.isCompleted;
    await MongoDatabase.updateQuest(quest);
    _fetchQuests(); // Refresh
  }

  // Show a dialog to add or edit a quest
  void _showQuestDialog({Quest? quest}) {
    // If a quest is passed, we are editing. Otherwise, we are adding.
    final bool isEditing = quest != null;

    final titleController = TextEditingController(text: quest?.title ?? '');
    final descriptionController =
    TextEditingController(text: quest?.description ?? '');
    final typeController = TextEditingController(text: quest?.type ?? '');
    final dueDateController = TextEditingController(text: quest?.dueDate ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Quest' : 'Add a Quest'),
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
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: dueDateController,
                decoration: InputDecoration(labelText: 'Due Date (e.g., YYYY-MM-DD)'),
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
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                if (isEditing) {
                  // Create updated quest object
                  final updatedQuest = Quest(
                    id: quest.id, // Keep the original ID
                    title: titleController.text,
                    description: descriptionController.text,
                    type: typeController.text,
                    dueDate: dueDateController.text,
                    isCompleted: quest.isCompleted, // Keep original status
                  );
                  _updateQuest(updatedQuest);
                } else {
                  // Add new quest
                  _addQuest(
                    titleController.text,
                    descriptionController.text,
                    typeController.text,
                    dueDateController.text,
                  );
                }
              }
            },
            child: Text(isEditing ? 'Save' : 'Add'),
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
      body: FutureBuilder<List<Quest>>(
        future: _questsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load quests: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No quests yet! Add one using the + button.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            // We have data, show the list
            final quests = snapshot.data!;
            return QuestList(
              quests: quests,
              onToggleComplete: (quest) => _toggleComplete(quest),
              onEdit: (quest) => _showQuestDialog(quest: quest),
              onDelete: (id) => _deleteQuest(id),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuestDialog(), // Show dialog to add
        child: Icon(Icons.add),
      ),
    );
  }
}