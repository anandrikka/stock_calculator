class AppUserConfigEntity {
  String configKey;
  String configValue;

  static const String TABLE = 'APP_USER_CONFIG';
  static const String COLUMN_CONFIG_KEY = 'CONFIG_KEY';
  static const String COLUMN_CONFIG_VALUE = 'CONFIG_VALUE';

  AppUserConfigEntity({this.configKey, this.configValue});

  AppUserConfigEntity.fromJson(Map<String, dynamic> json)
      : configKey = json[COLUMN_CONFIG_KEY],
        configValue = json[COLUMN_CONFIG_VALUE];

  Map<String, dynamic> toJson() {
    return {
      AppUserConfigEntity.COLUMN_CONFIG_KEY: this.configKey,
      AppUserConfigEntity.COLUMN_CONFIG_VALUE: this.configValue,
    };
  }
}
