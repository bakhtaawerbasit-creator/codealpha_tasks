import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/fitness_activity.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('fitness_tracker.db');

    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exerciseType TEXT NOT NULL,
        duration INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        steps INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertActivity(FitnessActivity activity) async {
    final db = await database;

    return await db.insert(
      'activities',
      activity.toMap(),
    );
  }

  Future<List<FitnessActivity>> getActivities() async {
    final db = await database;

    final result = await db.query(
      'activities',
      orderBy: 'date DESC',
    );

    return result
        .map((map) => FitnessActivity.fromMap(map))
        .toList();
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;

    return await db.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}