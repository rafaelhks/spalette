import 'dart:async';
import 'dart:io';
import 'package:mediapp/model/color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static Database _db;
  
  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await intDB();
    return _db;
  }

  intDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path , 'dbspalette.db');
    var myOwnDB = await openDatabase(path,version: 1,
        onCreate: _onCreate);
    return myOwnDB;
  }
  
  void _onCreate(Database db , int newVersion) async{
    await db.execute("CREATE TABLE IF NOT EXISTS "+PColor.table+" (${PColor.colId} INTEGER PRIMARY KEY,"
        " ${PColor.colRed} NUMERIC, ${PColor.colGreen} NUMERIC,"
        " ${PColor.colBlue} NUMERIC, ${PColor.colAlpha} NUMERIC,"
        "${PColor.colTag} TEXT);");
  }

  Future<PColor> getPColor() async{
    var dbClient = await  db;
    var sql = "SELECT * FROM "+PColor.table;
    var result = await dbClient.rawQuery(sql);
    if(result.isNotEmpty) return new PColor.fromMap(result.first);
    return null;
  }

  Future<int> saveOrUpdatePColor(PColor i) async{
      var dbClient = await  db;
      int result = 0;
      if(i.getId()!=null) {
        result = await dbClient.update(PColor.table, i.toMap(), where: '${PColor.colId} = ${i.getId()}');
      } else {
        result = await dbClient.insert(PColor.table, i.toMap());
      }
      return result;
  }

  Future<List> getAllPColor() async{
    var dbClient = await  db;
    var sql = "SELECT * FROM "+PColor.table+" ORDER BY "+PColor.colId+" DESC";
    List result = await dbClient.rawQuery(sql);
    return result.toList();
  }

  Future<List> getPColorsByTag(String tag) async{
    var dbClient = await  db;
    var sql = "SELECT * FROM "+PColor.table+" WHERE ${PColor.colTag} LIKE '%$tag%' ORDER BY "+PColor.colId+" DESC";
    List result = await dbClient.rawQuery(sql);
    return result.toList();
  }

  Future<int> deletePColor(var id) async{
      var dbClient = await  db;
      int result = 0;
      result = await dbClient.delete(PColor.table, where: '${PColor.colId} = $id');
      return result;
  }

  Future<void> close() async{
    var dbClient = await  db;
    return  await dbClient.close();
  }

}