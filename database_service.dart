// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/document.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'research_library.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE documents(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filePath TEXT NOT NULL,
            title TEXT,
            author TEXT,
            publicationDate TEXT,
            type TEXT,
            tags TEXT,
            notes TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertDocument(Document document) async {
    final db = await database;
    await db.insert(
      'documents',
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Document>> getDocuments() async {
    final db = await database;
    final maps = await db.query('documents');
    return maps.map((map) => Document.fromMap(map)).toList();
  }
}
