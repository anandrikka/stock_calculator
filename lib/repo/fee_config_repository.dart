import 'package:stockcalculator/dao/fee_config_dao.dart';
import 'package:stockcalculator/models/fee_config_entity.dart';
import 'package:stockcalculator/repo/base_repository.dart';
import 'package:stockcalculator/utils/enums.dart';

class FeeConfigRepository extends BaseRepository<String, FeeConfigEntity> {
  final FeeConfigDao _feeConfigDao = FeeConfigDao();

  @override
  // ignore: missing_return
  create(FeeConfigEntity t) {
    _feeConfigDao.create(t);
  }

  @override
  deleteById(String id) {
    _feeConfigDao.deleteById(id);
  }

  @override
  Future<List<FeeConfigEntity>> getAll() async {
    return _feeConfigDao.getAll();
  }

  @override
  Future<FeeConfigEntity> getById(String id) async {
    return _feeConfigDao.getById(id);
  }

  @override
  update(FeeConfigEntity t) {
    return _feeConfigDao.update(t);
  }

  updateMultipleFeeConfig(
      FeeType feeType, Map<TradingOption, String> values) async {
    String feeTypeVal = feeType.name;
    List<FeeConfigEntity> updateList = [];
    values.forEach((key, value) {
      FeeConfigEntity model = FeeConfigEntity();
      model.feeId = '$feeTypeVal.${key.value}';
      model.feeJson = value;
      updateList.add(model);
    });
    await _feeConfigDao.updateMultipleFeeConfig(updateList);
  }
}
