import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:quest_tracker/models/quest.dart';

class QuestList extends StatelessWidget {
  final List<Quest> quests;
  final Function(Quest) onToggleComplete;
  final Function(Quest) onEdit;
  final Function(ObjectId) onDelete;

  QuestList({
    required this.quests,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quests.length,
      itemBuilder: (ctx, index) {
        final quest = quests[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: quest.isCompleted,
              onChanged: (value) => onToggleComplete(quest),
            ),
            title: Text(
              quest.title,
              style: TextStyle(
                decoration: quest.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(quest.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit(quest),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(quest.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}