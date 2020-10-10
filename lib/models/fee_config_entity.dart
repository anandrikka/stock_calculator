import 'package:stock_calculator/utils/enums.dart';

class FeeConfigEntity {
  static const String TABLE = 'FEES_CONFIG';
  static const String COLUMN_FEE_ID = 'FEE_ID';
  static const String COLUMN_FEE_JSON = 'FEE_JSON';

  String feeId;
  String feeJson;

  FeeConfigEntity();

  FeeType get feeType => feeId.split('.')[0].convertToFeeType();

  TradingOption get tradingOption =>
      feeId.split('.')[1].convertToTradingOption();

  Map<String, dynamic> toJson() {
    return {
      FeeConfigEntity.COLUMN_FEE_ID: feeId,
      FeeConfigEntity.COLUMN_FEE_JSON: feeJson,
    };
  }

  FeeConfigEntity.fromJson(Map<String, dynamic> json)
      : feeId = json[COLUMN_FEE_ID],
        feeJson = json[COLUMN_FEE_JSON];
}
