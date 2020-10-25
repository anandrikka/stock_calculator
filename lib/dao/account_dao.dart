import 'package:sqflite/sqflite.dart';
import 'package:stockcalculator/dao/base_dao.dart';
import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/models/option.dart';

class AccountDao extends BaseDao<int, AccountEntity> {
  @override
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

  Future<List<Option<int>>> getAllActiveAccountsByName() async {
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      columns: [
        AccountEntity.COLUMN_ID,
        AccountEntity.COLUMN_ACCOUNT_NAME,
      ],
      where: '${AccountEntity.COLUMN_IS_ACTIVE} = ?',
      whereArgs: [1],
    );
    return result.length > 0
        ? List.generate(result.length, (index) {
            Option<int> option = Option(
              value: result.elementAt(index)[AccountEntity.COLUMN_ID] as int,
              label: result.elementAt(index)[AccountEntity.COLUMN_ACCOUNT_NAME]
                  as String,
            );
            return option;
          })
        : [];
  }

  removeAccount(int id) async {
    Database db = await dbProvider.database;
    await db.delete(
      table,
      where: '${AccountEntity.COLUMN_ID} = ?',
      whereArgs: [id],
    );
  }
}
