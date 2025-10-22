// lib/services/local_db.dart
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:io';
import 'package:quest_tracker/models/quest.dart';

class LocalDatabase {
  static final LocalDatabase _singleton = LocalDatabase._internal();
  LocalDatabase._internal();

  factory LocalDatabase() => _singleton;

  static const String DB_NAME = 'quest_tracker.db';
  static const String STORE_NAME = 'quests';

  Database? _db; // made nullable
  final _store = intMapStoreFactory.store(STORE_NAME);

  Future<void> init() async {
    if (_db != null && _db!.isOpen) return;

    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = '${dir.path}/$DB_NAME';
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<List<Quest>> getAllQuests() async {
    final records = await _store.find(_db!);
    return records
        .map((r) => Quest.fromMap(Map<String, dynamic>.from(r.value), id: r.key.toString()))
        .toList();
  }

  Future<Quest> addQuest(Quest quest) async {
    final key = await _store.add(_db!, quest.toMap());
    quest.id = key.toString();
    return quest;
  }

  Future<void> updateQuest(Quest quest) async {
    if (quest.id == null) return;
    final intKey = int.tryParse(quest.id!);
    if (intKey == null) return;
    await _store.record(intKey).update(_db!, quest.toMap());
  }

  Future<void> deleteQuest(String id) async {
    final intKey = int.tryParse(id);
    if (intKey == null) return;
    await _store.record(intKey).delete(_db!);
  }
}

extension on Database {
  bool get isOpen => this != null && !this.isClosed;

  bool get isClosed => this == null || this.isClosed;
}
