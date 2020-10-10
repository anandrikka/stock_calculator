import 'package:stock_calculator/models/option.dart';
import 'package:stock_calculator/utils/enums.dart';

class EnumsAsList {
  static List<Option<TradingOption>> getTradingOptions() => TradingOption.values
      .map((v) => Option<TradingOption>(label: v.label, value: v))
      .toList();

  static List<Option<TradeExchange>> getTradeExchanges() => TradeExchange.values
      .map((v) => Option<TradeExchange>(label: v.name, value: v))
      .toList();
}
