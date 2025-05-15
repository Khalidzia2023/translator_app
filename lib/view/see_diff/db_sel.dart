

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:mnh/view/see_diff/model_sel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DBbtm{

  late Database _dbBtm;

   Future<void> initDatabase() async{

     final databasePath = await getDatabasesPath();
     final path = join(databasePath, 'LearnItalian.db');

     final isExist = await databaseExists(path);

     if(!isExist) {
       try{
         await Directory(dirname(path)).create(recursive: true);
     }catch(e){
         print('error generating in directory');
     }

     ByteData data = await rootBundle.load('assets/data_base/LearnItalian.db');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes
      ) ;
     await File(path).writeAsBytes(bytes);
     }else{
       print('DB already had');
     }
     _dbBtm = await openDatabase(path);


   }


  Future<List<BtmModel>> getDataher() async{
     if(_dbBtm == null){
       throw Exception("db not init");
     }
     final List<Map<String, dynamic>> map = await _dbBtm.query('category');
     print("fetch.... ${map.length} <-----> records from 'category'");


     return map.isNotEmpty
         ? List.generate(
         map.length,
         (i) => BtmModel.fromMap(map[i]))
         : [];

  }

}