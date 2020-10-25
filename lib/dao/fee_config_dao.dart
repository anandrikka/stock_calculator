import 'package:stockcalculator/dao/base_dao.dart';
import 'package:stockcalculator/models/fee_config_entity.dart';

class FeeConfigDao extends BaseDao<String, FeeConfigEntity> {
  @override
  List<String> get columns =>
      [FeeConfigEntity.COLUMN_FEE_ID, FeeConfigEntity.COLUMN_FEE_JSON];

  @override
  FeeConfigEntity fromDbJson(Map<String, dynamic> json) =>
      FeeConfigEntity.fromJson(json);

  @override
  String getId(FeeConfigEntity t) => t.feeId;

  @override
  String get primaryColumn => FeeConfigEntity.COLUMN_FEE_ID;

  @override
  String get table => FeeConfigEntity.TABLE;

  @override
  Map<String, dynamic> toDbJson(FeeConfigEntity t) => t.toJson();

  updateMultipleFeeConfig(List<FeeConfigEntity> records) async {
    var db = await dbProvider.database;
    await db.transaction(
      (txn) async {
        var batch = txn.batch();
        records.forEach((record) {
          batch.update(
            table,
            toDbJson(record),
            where: "$primaryColumn = ?",
            whereArgs: [record.feeId],
          );
        });
        await batch.commit(continueOnError: false, noResult: true);
      },
    );
  }
}
