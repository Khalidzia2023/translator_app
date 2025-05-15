

import 'package:mnh/testor/model/mod_lang.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBCreation {
  late Database _dbc;


  Future<void> initDatabase() async {

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'LearnItalian.db');

    final isExist = await databaseExists(path);

    if (!isExist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print("error creating directory");
      }

      ByteData data = await rootBundle.load('assets/data_base/LearnItalian.db');
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    } else {
      print("database already exists");
    }
    _dbc = await openDatabase(path);
  }

  Future<List<SelectLangModel>> getCat() async {
    if (_dbc == Null) {
      throw Exception("DB not initialized.call it first");
    }
    final List<Map<String, dynamic>> map = await _dbc.query("category");
    print("Fetching.... ${map.length} <=====> records from 'category'");

    return map.isNotEmpty
        ? List.generate(
        map.length, (i) => SelectLangModel.fromMap(map[i]))
        : [];
  }
}


