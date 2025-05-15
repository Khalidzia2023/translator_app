import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('LearnItalian.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print("Database path: $path");

    var file = File(path);

    // Check if the file already exists in the local storage
    if (!file.existsSync()) {
      // If not, load it from assets
      try {
        ByteData data = await rootBundle.load('assets/data_base/LearnItalian.db');
        List<int> bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes);
        print("Database copied from assets.");
      } catch (e) {
        print("Error copying database from assets: $e");
      }
    } else {
      print("Database already exists at path.");
    }

    // Open the database after ensuring it exists
    return await openDatabase(path, version: 1);
  }

  Future<List<String>> getLanguages() async {
    final db = await database;
    final result = await db.query('category'); // Fetch all records from 'category' table
    print("Query result: $result");
    return result.map((row) => row['name'] as String).toList();
  }
}
