import 'dart:ffi';

import 'package:stock_calculator/utils/constants.dart';

enum TradingOption {
  EQUITY_DELIVERY,
  EQUITY_INTRADAY,
  EQUITY_FUTURES,
  EQUITY_OPTIONS,
  CURRENCY_FUTURES,
  CURRENCY_OPTIONS,
  COMMODITIES_FUTURES,
  COMMODITIES_OPTIONS,
}

enum TradeExchange { BSE, NSE }

enum TabItem {
  CALCULATOR,
  // ACCOUNTS,
  SETTINGS
}

enum UserPreference {
  DEFAULT_ACCOUNT,
  DEFAULT_TRADING_OPTION,
  DEFAULT_EXCHANGE,
  USE_MULTIPLE_ACCOUNTS,
}

enum FeeType {
  SECURITY_TRANSACTION_TAX,
  EXCHANGE_TRANSACTION_TAX_BSE,
  EXCHANGE_TRANSACTION_TAX_NSE,
  GST,
  SEBI,
  STAMP_DUTY,
}

extension DoubleExtension on double {
  String toStringSafe() {
    if (null == this || this.isNaN) return '0.0';
    return this.toString();
  }

  bool isEmpty() {
    return null == this || this.isNaN || this <= 0;
  }

  bool isNotEmpty() {
    return !this.isEmpty();
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  TradingOption convertToTradingOption() => TradingOption.values
      .firstWhere((tradeOption) => this == tradeOption.value);

  TradeExchange convertToExchange() =>
      TradeExchange.values.firstWhere((exchange) => this == exchange.name);
  bool convertToBoolean() => this.toUpperCase() == 'TRUE';

  FeeType convertToFeeType() =>
      FeeType.values.firstWhere((feeType) => this == feeType.name);

  UserPreference convertToUserPref() =>
      UserPreference.values.firstWhere((userPref) => this == userPref.name);

  double convertToDouble() {
    if (null == this || this.isEmpty || '' == this) {
      return 0.0;
    }
    return double.tryParse(this);
  }
}

extension TradingOptionsExtension on TradingOption {
  String get value => constructNameForEnum(this);
  String get group => constructNameForEnum(this).split('_')[0];
  String get type => constructNameForEnum(this).split('_')[1];
  String get groupLabel => group.toLowerCase().capitalize();
  String get typeLabel => type.toLowerCase().capitalize();
  String get label =>
      '${group.toLowerCase().capitalize()} - ${type.toLowerCase().capitalize()}';
}

extension TabItemExtension on TabItem {
  String get name => constructNameForEnum(this);
  String get label => name.capitalize();
}

extension UserPreferencesExtension on UserPreference {
  String get name => constructNameForEnum(this);
}

extension FeeTypesExtension on FeeType {
  String get name => constructNameForEnum(this);
}

extension TradeExchangeExtension on TradeExchange {
  String get name => constructNameForEnum(this);
}
