import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_calculator/sql/v1.dart';

class DatabaseProvider {
  static const _dbName = 'stock_calculator.db';
  static const _dbVersion = 1;
  DatabaseProvider._();
  static final DatabaseProvider dbProvider = DatabaseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    await Sqflite.setDebugModeOn();
    Directory dataDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDir.path, _dbName);
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreateDB,
      singleInstance: true,
      onUpgrade: _onUpgradeDB,
    );
  }

  _onCreateDB(Database db, int version) async {
    print("About to execute initial DB Script.");
    try {
      var sql = sql_v1;
      var statements = sql
          .split('\n')
          .where((stmt) => stmt.isNotEmpty && stmt.length > 0)
          .toList();
      Batch batch = db.batch();
      statements.forEach((stmt) => batch.execute(stmt));
      batch.commit(noResult: true, continueOnError: false);
    } catch (e) {
      print(e);
    }
  }

  _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    print("Abount to execute upgrade script...");
  }
}
