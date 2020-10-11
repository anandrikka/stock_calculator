import 'package:sqflite/sqflite.dart';
import 'package:stockcalculator/dao/base_dao.dart';
import 'package:stockcalculator/models/account_entity.dart';

class AccountDao extends BaseDao<int, AccountEntity> {
  @override
  // TODO: implement columns
  List<String> get columns => [
        AccountEntity.COLUMN_ID,
        AccountEntity.COLUMN_ACCOUNT_NAME,
        AccountEntity.COLUMN_DP_FEE,
        AccountEntity.COLUMN_IS_ACTIVE,
        AccountEntity.COLUMN_FEES_JSON,
      ];

  @override
  AccountEntity fromDbJson(Map<String, dynamic> json) =>
      AccountEntity.fromJson(json);

  @override
  int getId(AccountEntity t) => t.id;

  @override
  String get primaryColumn => AccountEntity.COLUMN_ID;

  @override
  String get table => AccountEntity.TABLE;

  @override
  Map<String, dynamic> toDbJson(AccountEntity t) => t.toJson();

  Future<List<AccountEntity>> getAllActiveAccounts() async {
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      columns: columns,
      where: '${AccountEntity.COLUMN_IS_ACTIVE} = ?',
      whereArgs: [1],
    );
    return result.length > 0
        ? List.generate(result.length, (index) => fromDbJson(result[index]))
        : [];
  }
}
