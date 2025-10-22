// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:quest_tracker/models/quest.dart';
import 'package:quest_tracker/services/local_db.dart';
import 'package:quest_tracker/widgets/quest_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Quest>> _questsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _questsFuture = LocalDatabase().getAllQuests();
    });
  }

  Future<void> _showQuestDialog({Quest? quest}) async {
    final titleCtrl = TextEditingController(text: quest?.title ?? '');
    final descCtrl = TextEditingController(text: quest?.description ?? '');
    final typeCtrl = TextEditingController(text: quest?.type ?? '');
    final dueCtrl = TextEditingController(text: quest?.dueDate ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(quest == null ? 'Add Quest' : 'Edit Quest'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Title')),
              TextField(controller: descCtrl, decoration: InputDecoration(labelText: 'Description')),
              TextField(controller: typeCtrl, decoration: InputDecoration(labelText: 'Type')),
              TextField(controller: dueCtrl, decoration: InputDecoration(labelText: 'Due Date')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newQuest = Quest(
                id: quest?.id,
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                type: typeCtrl.text.trim(),
                dueDate: dueCtrl.text.trim(),
                isCompleted: quest?.isCompleted ?? false,
              );
              if (quest == null) {
                await LocalDatabase().addQuest(newQuest);
              } else {
                await LocalDatabase().updateQuest(newQuest);
              }
              Navigator.of(ctx).pop(true);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) _refresh();
  }

  Future<void> _toggleComplete(Quest quest) async {
    quest.isCompleted = !quest.isCompleted;
    await LocalDatabase().updateQuest(quest);
    _refresh();
  }

  Future<void> _deleteQuest(String id) async {
    await LocalDatabase().deleteQuest(id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Life Quest Tracker (Local Demo)'),
      ),
      body: FutureBuilder<List<Quest>>(
        future: _questsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final quests = snapshot.data ?? [];
          if (quests.isEmpty) {
            return Center(child: Text('No quests yet — add one with +'));
          }
          return QuestList(
            quests: quests,
            onToggleComplete: _toggleComplete,
            onEdit: (q) => _showQuestDialog(quest: q),
            onDelete: (id) => _deleteQuest(id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuestDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
