import 'package:stockcalculator/database/database_provider.dart';

abstract class BaseDao<K, T> {
  DatabaseProvider dbProvider = DatabaseProvider.dbProvider;

  String get table;
  List<String> get columns;
  String get primaryColumn;

  Future<int> create(T t) async {
    final db = await dbProvider.database;
    var result = await db.insert(table, toDbJson(t));
    return result;
  }

  Future<int> update(T t) async {
    final db = await dbProvider.database;
    K id = getId(t);
    var result = await db.update(
      table,
      toDbJson(t),
      where: "$primaryColumn = ?",
      whereArgs: [id],
    );
    return result;
  }

  Future<T> getById(K k) async {
    final db = await dbProvider.database;
    var result = await db.query(table,
        columns: columns, where: '$primaryColumn = ?', whereArgs: [k]);
    return result.isNotEmpty ? fromDbJson(result.first) : null;
  }

  Future<int> deleteById(K id) async {
    final db = await dbProvider.database;
    var result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<T>> getAll() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(table, columns: columns);
    return result.isNotEmpty
        ? List.generate(result.length, (i) => fromDbJson(result[i]))
        : [];
  }

  Map<String, dynamic> toDbJson(T t);

  T fromDbJson(Map<String, dynamic> json);

  K getId(T t);
}
