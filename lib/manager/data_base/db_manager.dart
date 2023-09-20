import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/logger/logger.dart';


class DBManager {
  static Database? _database;
  int versionCode=3;
  Future<Database> get database async {

    if (_database == null) {
      _database = await initDB();
      return _database!;
    } else {
      if (await _database!.getVersion() < versionCode){
        printLog("versionCode", _database!.getVersion());
        _database = await initDB();
        return _database!;
      }

      return _database!;
    }
  }

  initDB() async {
    String dbPaths = await getDatabasesPath();
    String path = join(dbPaths, 'finetaste.db');
    print(path);
    return await openDatabase(path, version: versionCode, onUpgrade: _onUpgrade,onCreate: (db, version) async {
      String script = await rootBundle.loadString("script/local_db/db_struct.sql");
      List<String> scripts = script.split(";");

      scripts.forEach((v) {
        if (v.isNotEmpty) {
          print(v.trim());
          db.execute(v.trim());
        }
      });
    });
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    printLog("oldVersion", oldVersion);
    printLog("newVersion", newVersion);
  }

  Future<int> insert<T>(Map<String, dynamic> row) async {
    printLog("SQLFLITE:: data insert : ",row);
    final db = await database;

    final result = db.insert(T.toString(), row);

    result.catchError((e) {
      printLog("SQLFLITE:: Error on insert", e.toString());
    });

    return result;
  }

  Future<List<Map<String, dynamic>>> queryAllRows<T>() async {
    Database db = await database;

    final result = db.query(T.toString());

    result.catchError((e) {
      printLog("SQLFLITE:: Error on query", e.toString());
    });

    return result;
  }

  Future<int> update<T>(Map<String, dynamic> row) async {
    print("data update:$row");
    Database db = await database;
    String id = row['id'].toString();

    final result =
    db.update(T.toString(), row, where: '$id = ?', whereArgs: [id]);

    result.catchError((e) {
      printLog("SQLFLITE:: Error on update", e.toString());
    });

    return result;
  }

  Future<int> delete<T>() async {
    final db = await database;

    final result = db.delete(T.toString());

    result.catchError((e) {
      printLog("SQLFLITE:: Error on delete all", e.toString());
    });

    return result;
  }



}