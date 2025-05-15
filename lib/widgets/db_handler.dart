import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/langModel.dart';


class DBHandler {
  late Database _database;


  Future<void> initDatabase()async{

    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, 'LearnItalian.db');

    final isExist = await databaseExists(path);

    if(!isExist){
      try{
        await Directory(dirname(path)).create(recursive: true);
      }catch(e){
        print('==========>Directory create error');
      }
      // ByteData data = await rootBundle.load('assets/data_base/LearnItalian.db');
      ByteData data=await rootBundle.load('assets/data_base/LearnItalian.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }else{
      print("existence database");
    }
    _database = await openDatabase(path);
  }

  Future<List<LangModel>> fetchDataCat() async {
    if (_database == null) {
      throw Exception("Database not initialized. Call initDatabase first.");
    }

    final List<Map<String, dynamic>> map = await _database.query("category");
    print("Fetched ${map.length} records from 'category'");

    return map.isNotEmpty
        ? List.generate(map.length, (i) => LangModel.fromMap(map[i]))
        : [];
  }


}