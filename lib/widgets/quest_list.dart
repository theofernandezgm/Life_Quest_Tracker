import 'package:flutter/material.dart';
import 'package:quest_tracker/models/quest.dart';

class QuestList extends StatelessWidget {
  final List<Quest> quests;
  final Function(int) onToggleComplete;

  QuestList({required this.quests, required this.onToggleComplete});
  @override
  Widget build(BuildContext context) {
    return quests.isEmpty
        ? Center(
      child: Text(
        'No quests yet! Add one using the + button.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    )
        : ListView.builder(
      itemCount: quests.length,
      itemBuilder: (ctx, index) {
        final quest = quests[index];
        return ListTile(
          title: Text(quest.title),
          subtitle: Text(quest.description),
          trailing: Checkbox(
            value: quest.isCompleted,
            onChanged: (value) => onToggleComplete(index),
          ),
        );
      },
    );
  }
}
