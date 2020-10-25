import 'package:stockcalculator/dao/app_user_config_dao.dart';
import 'package:stockcalculator/models/app_user_config_entity.dart';
import 'package:stockcalculator/repo/base_repository.dart';

class AppUserConfigRepository
    extends BaseRepository<String, AppUserConfigEntity> {
  final AppUserConfigDao _appUserConfigDao = AppUserConfigDao();

  @override
  Future<List<AppUserConfigEntity>> getAll() async {
    return await _appUserConfigDao.getAll();
  }

  @override
  update(AppUserConfigEntity appUserConfig) async {
    try {
      await _appUserConfigDao.update(appUserConfig);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  // ignore: missing_return
  create(t) {
    _appUserConfigDao.create(t);
  }

  @override
  deleteById(id) {
    _appUserConfigDao.deleteById(id);
  }

  @override
  Future<AppUserConfigEntity> getById(id) async {
    return await _appUserConfigDao.getById(id);
  }
}
