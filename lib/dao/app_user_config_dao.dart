import 'package:stockcalculator/dao/base_dao.dart';
import 'package:stockcalculator/models/app_user_config_entity.dart';

class AppUserConfigDao extends BaseDao<String, AppUserConfigEntity> {
  @override
  fromDbJson(json) => AppUserConfigEntity.fromJson(json);

  @override
  String getId(t) => t.configKey;

  @override
  Map<String, dynamic> toDbJson(t) => t.toJson();

  @override
  List<String> get columns => [
        AppUserConfigEntity.COLUMN_CONFIG_KEY,
        AppUserConfigEntity.COLUMN_CONFIG_VALUE
      ];

  @override
  String get primaryColumn => AppUserConfigEntity.COLUMN_CONFIG_KEY;

  @override
  String get table => AppUserConfigEntity.TABLE;
}
