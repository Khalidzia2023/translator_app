import 'package:flutter/cupertino.dart';
import 'package:mnh/models/languageModel.dart';
import 'package:mnh/models/phrase_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class DbHelper {
  late Database _db;

  Future<void> initDatabase() async {

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'LearnItalian.db');

    final isExist = await databaseExists(path);

    if (!isExist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print("error creating directoy");
      }

      ByteData data = await rootBundle.load('assets/data_base/LearnItalian.db');
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes
      );
      await File(path).writeAsBytes(bytes);
    }
    else {
      print("existence database check noe");
    }
    _db = await openDatabase(path);
  }

  /// Example function to fetch data


  Future<List<LanguageModel>> fetchCategory() async {
    if (_db == null) {
      throw Exception("Database not initialized. Call initDatabase first.");
    }

    final List<Map<String, dynamic>> map = await _db.query('category');
    print("Fetched ${map.length} records from 'category'");

    return map.isNotEmpty
        ? List.generate(map.length, (i) => LanguageModel.fromMap(map[i]))
        : [];
  }


  Future<List<PhrasesModel>> fetchPhrases() async {
    final List<Map<String, dynamic>> phrasesMap = await _db.query('phrase');
    print("fetch or load... ${phrasesMap.length} records from 'phrase'");

    return phrasesMap.isNotEmpty
        ? List.generate(
        phrasesMap.length, (i) => PhrasesModel.fromMap(phrasesMap[i]))
        : [];
  }

}



