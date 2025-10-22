// lib/widgets/quest_list.dart
import 'package:flutter/material.dart';
import 'package:quest_tracker/models/quest.dart';

class QuestList extends StatelessWidget {
  final List<Quest> quests;
  final void Function(Quest) onToggleComplete;
  final void Function(Quest) onEdit;
  final void Function(String) onDelete;

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
      itemBuilder: (context, index) {
        final quest = quests[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: IconButton(
              icon: Icon(quest.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
              onPressed: () => onToggleComplete(quest),
            ),
            title: Text(quest.title),
            subtitle: Text('${quest.type} • Due: ${quest.dueDate}\n${quest.description}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () => onEdit(quest)),
                IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => onDelete(quest.id ?? '')),
              ],
            ),
          ),
        );
      },
    );
  }
}
