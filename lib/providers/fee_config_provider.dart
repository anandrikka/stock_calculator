import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockcalculator/models/fee_config_entity.dart';
import 'package:stockcalculator/models/fee_model.dart';
import 'package:stockcalculator/repo/fee_config_repository.dart';
import 'package:stockcalculator/utils/enums.dart';

class FeeConfigProvider extends ChangeNotifier {
  final FeeConfigRepository _feeConfigRepository = FeeConfigRepository();
  bool loaded = false;
  Map<FeeType, Map<TradingOption, dynamic>> _feeConfig = {};

  Map<FeeType, Map<TradingOption, dynamic>> get feeConfig => _feeConfig;

  FeeConfigProvider() {
    _fetchFeeConfigItems();
  }

  _fetchFeeConfigItems() async {
    List<FeeConfigEntity> result = await _feeConfigRepository.getAll();
    result.forEach((fcm) {
      _feeConfig.putIfAbsent(fcm.feeType, () => {});
      _feeConfig[fcm.feeType].putIfAbsent(fcm.tradingOption, () => '');
      if (FeeType.SECURITY_TRANSACTION_TAX == fcm.feeType ||
          FeeType.STAMP_DUTY == fcm.feeType) {
        _feeConfig[fcm.feeType][fcm.tradingOption] =
            BuySellModel.fromJson(jsonDecode(fcm.feeJson));
      } else if (FeeType.GST == fcm.feeType ||
          FeeType.SEBI == fcm.feeType ||
          FeeType.EXCHANGE_TRANSACTION_TAX_BSE == fcm.feeType ||
          FeeType.EXCHANGE_TRANSACTION_TAX_NSE == fcm.feeType) {
        _feeConfig[fcm.feeType][fcm.tradingOption] =
            FeeModel.fromJson(jsonDecode(fcm.feeJson));
      } else {
        _feeConfig[fcm.feeType][fcm.tradingOption] = jsonDecode(fcm.feeJson);
      }
    });
    loaded = true;
    notifyListeners();
  }

  updateFeeConfigItems(
      FeeType feeType, Map<TradingOption, dynamic> feeConfigItems) async {
    Map<TradingOption, String> result = {};
    if (FeeType.SECURITY_TRANSACTION_TAX == feeType ||
        FeeType.STAMP_DUTY == feeType) {
      result = feeConfigItems.map((key, value) {
        var _val = value as BuySellModel;
        _feeConfig[feeType][key] = _val;
        return MapEntry(key, jsonEncode(_val.toJson()));
      });
    } else if (FeeType.GST == feeType ||
        FeeType.SEBI == feeType ||
        FeeType.EXCHANGE_TRANSACTION_TAX_BSE == feeType ||
        FeeType.EXCHANGE_TRANSACTION_TAX_NSE == feeType) {
      result = feeConfigItems.map((key, value) {
        var _val = value as FeeModel;
        _feeConfig[feeType][key] = _val;
        return MapEntry(key, jsonEncode(_val.toJson()));
      });
    }
    await _feeConfigRepository.updateMultipleFeeConfig(feeType, result);
    notifyListeners();
  }
}
