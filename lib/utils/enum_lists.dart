import 'package:stockcalculator/models/option.dart';
import 'package:stockcalculator/utils/enums.dart';

class EnumsAsList {
  static List<Option<TradingOption>> getTradingOptions() => TradingOption.values
      .map((v) => Option<TradingOption>(label: v.label, value: v))
      .toList();

  static List<Option<TradeExchange>> getTradeExchanges() => TradeExchange.values
      .map((v) => Option<TradeExchange>(label: v.name, value: v))
      .toList();
}
