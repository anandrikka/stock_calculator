import 'package:flutter/material.dart';
import 'package:stock_calculator/models/app_user_config_entity.dart';
import 'package:stock_calculator/repo/app_user_config_repository.dart';
import 'package:stock_calculator/utils/enums.dart';

class AppUserConfigProvider extends ChangeNotifier {
  Map<UserPreference, dynamic> _userConfig = {
    UserPreference.DEFAULT_TRADING_OPTION: TradingOption.EQUITY_DELIVERY,
    UserPreference.DEFAULT_EXCHANGE: TradeExchange.NSE,
    UserPreference.USE_MULTIPLE_ACCOUNTS: false,
    UserPreference.DEFAULT_ACCOUNT: 1,
  };

  final AppUserConfigRepository _appUserConfigRepo = AppUserConfigRepository();

  AppUserConfigProvider() {
    fetchAllUserConfiguration();
  }

  fetchAllUserConfiguration() async {
    var result = await _appUserConfigRepo.getAll();
    result.forEach((AppUserConfigEntity config) {
      if (UserPreference.DEFAULT_TRADING_OPTION.name == config.configKey) {
        _userConfig[config.configKey.convertToUserPref()] =
            config.configValue.convertToTradingOption();
      } else if (UserPreference.DEFAULT_EXCHANGE.name == config.configKey) {
        _userConfig[config.configKey.convertToUserPref()] =
            config.configValue.convertToExchange();
      } else if (UserPreference.USE_MULTIPLE_ACCOUNTS.name ==
          config.configKey) {
        _userConfig[config.configKey.convertToUserPref()] =
            config.configValue.convertToBoolean();
      } else if (UserPreference.DEFAULT_ACCOUNT.name == config.configKey) {
        _userConfig[config.configKey.convertToUserPref()] =
            int.parse(config.configValue);
      }
    });
    notifyListeners();
  }

  Map<UserPreference, dynamic> get userConfig => _userConfig;

  getConfigValue(UserPreference key) {
    return _userConfig[key];
  }

  setConfigValue(UserPreference key, dynamic value) {
    _userConfig[key] = value;
    if (key == UserPreference.DEFAULT_TRADING_OPTION) {
      _appUserConfigRepo.update(
        AppUserConfigEntity(
          configKey: key.name,
          configValue: (value as TradingOption).value,
        ),
      );
    } else if (key == UserPreference.DEFAULT_EXCHANGE) {
      _appUserConfigRepo.update(
        AppUserConfigEntity(
          configKey: key.name,
          configValue: (value as TradeExchange).name,
        ),
      );
    } else if (key == UserPreference.USE_MULTIPLE_ACCOUNTS) {
      _appUserConfigRepo.update(
        AppUserConfigEntity(
          configKey: key.name,
          configValue: (value as bool).toString(),
        ),
      );
    } else if (key == UserPreference.DEFAULT_ACCOUNT) {
      _appUserConfigRepo.update(
        AppUserConfigEntity(
          configKey: key.name,
          configValue: (value as int).toString(),
        ),
      );
    }
    notifyListeners();
  }
}
