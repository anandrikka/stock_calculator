import 'dart:convert';

import 'package:stockcalculator/models/account_fee_model.dart';
import 'package:stockcalculator/utils/enums.dart';

class AccountEntity {
  static const String TABLE = 'ACCOUNT';
  static const String COLUMN_ID = 'ID';
  static const String COLUMN_ACCOUNT_NAME = 'ACCOUNT_NAME';
  static const String COLUMN_DP_FEE = 'DP_FEE';
  static const String COLUMN_FEES_JSON = 'FEES_JSON';
  static const String COLUMN_IS_ACTIVE = 'IS_ACTIVE';

  int id;
  String accountName;
  int isActive;
  Map<TradingOption, AccountFeeModel> fees;
  double dpFee;

  AccountEntity();

  bool get active => isActive == 1;
  set active(bool flag) => flag ? 1 : 0;

  Map<String, dynamic> toJson() {
    return {
      COLUMN_ID: this.id,
      COLUMN_ACCOUNT_NAME: this.accountName,
      COLUMN_IS_ACTIVE: isActive,
      COLUMN_DP_FEE: this.dpFee,
      COLUMN_FEES_JSON: jsonEncode(
        this.fees.map(
              (key, value) => MapEntry(
                key.value,
                value.toJson(),
              ),
            ),
      ),
    };
  }

  AccountEntity.fromJson(Map<String, dynamic> json)
      : id = json[COLUMN_ID] as int,
        accountName = json[COLUMN_ACCOUNT_NAME] as String,
        isActive = json[COLUMN_IS_ACTIVE] as int,
        dpFee = json[COLUMN_DP_FEE] as double,
        fees = constructFees(json[COLUMN_FEES_JSON] as String);

  static Map<TradingOption, AccountFeeModel> constructFees(String json) =>
      (jsonDecode(json) as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key.convertToTradingOption(),
          AccountFeeModel.fromJson(value as Map<String, dynamic>),
        ),
      );

  static AccountEntity create() {
    var accountEntity = AccountEntity();
    accountEntity.fees = {
      TradingOption.EQUITY_DELIVERY: AccountFeeModel(),
      TradingOption.EQUITY_INTRADAY: AccountFeeModel(),
      TradingOption.EQUITY_FUTURES: AccountFeeModel(),
      TradingOption.EQUITY_OPTIONS: AccountFeeModel(),
      TradingOption.CURRENCY_FUTURES: AccountFeeModel(),
      TradingOption.CURRENCY_OPTIONS: AccountFeeModel(),
      TradingOption.COMMODITIES_FUTURES: AccountFeeModel(),
      TradingOption.COMMODITIES_OPTIONS: AccountFeeModel(),
    };
    return accountEntity;
  }
}
