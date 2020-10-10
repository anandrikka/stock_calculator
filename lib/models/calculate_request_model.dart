import 'dart:convert';

import 'package:stock_calculator/models/account_entity.dart';
import 'package:stock_calculator/models/calculate_response_model.dart';
import 'package:stock_calculator/models/fee_model.dart';
import 'package:stock_calculator/utils/enums.dart';

class CalculateRequestModel {
  final TradingOption tradeType;
  final TradeExchange exchange;
  final AccountEntity account;
  final double buyPrice;
  final double sellPrice;
  double quantity;
  final double amount;
  final Map<FeeType, Map<TradingOption, dynamic>> fees;
  double commodity;
  double strikePrice;

  CalculateRequestModel({
    this.tradeType,
    this.exchange,
    this.account,
    this.buyPrice,
    this.sellPrice,
    this.quantity,
    this.amount,
    this.fees,
    this.commodity,
    this.strikePrice,
  });

  CalculateResponseModel get calculationResult {
    CalculateResponseModel response = CalculateResponseModel();
    // transaction amount
    if (quantity > 0) {
      response.buyTransactionAmount = buyPrice * quantity;
      response.sellTransactionAmount = sellPrice * quantity;
    } else if (amount > 0) {
      response.buyTransactionAmount = amount;
      quantity = (amount / buyPrice).floorToDouble();
    }
    // Brokerage
    FeeModel accountFee = account.fees[tradeType];
    if (accountFee.flat) {
      if (response.buyTransactionAmount.isNotEmpty()) {
        response.brokerage += accountFee.flatRate;
      }
      if (response.sellTransactionAmount.isNotEmpty()) {
        response.brokerage += accountFee.flatRate;
      }
    } else {
      var buyBrokerage =
          response.buyTransactionAmount * accountFee.percent / 100;
      var sellBrokerage =
          response.sellTransactionAmount * accountFee.percent / 100;
      if (accountFee.min.isNotEmpty() && buyBrokerage < accountFee.min) {
        buyBrokerage = accountFee.min;
      }
      if (accountFee.min.isNotEmpty() && sellBrokerage < accountFee.min) {
        sellBrokerage = accountFee.min;
      }
      if (accountFee.max.isNotEmpty() && buyBrokerage > accountFee.max) {
        buyBrokerage = accountFee.max;
      }
      if (accountFee.max.isNotEmpty() && sellBrokerage > accountFee.max) {
        sellBrokerage = accountFee.max;
      }
      response.brokerage = buyBrokerage + sellBrokerage;
    }
    // SST
    if (fees.containsKey(FeeType.SECURITY_TRANSACTION_TAX)) {
      BuySellModel sstFees =
          fees[FeeType.SECURITY_TRANSACTION_TAX][tradeType] as BuySellModel;
      response.sst =
          (response.buyTransactionAmount * sstFees.buy.percent / 100) +
              (response.sellTransactionAmount * sstFees.sell.percent / 100);
    }

    // Exchange
    FeeType exchangeFeeType = exchange == TradeExchange.BSE
        ? FeeType.EXCHANGE_TRANSACTION_TAX_BSE
        : FeeType.EXCHANGE_TRANSACTION_TAX_NSE;
    if (fees.containsKey(exchangeFeeType)) {
      FeeModel exchangeFees = fees[exchangeFeeType][tradeType] as FeeModel;
      response.exchange =
          response.transactionAmount * exchangeFees.percent / 100;
    }
    // GST
    if (fees.containsKey(FeeType.GST)) {
      FeeModel gstFees = fees[FeeType.GST][tradeType] as FeeModel;
      response.gst =
          (response.brokerage + response.exchange) * gstFees.percent / 100;
    }
    // SEBI
    if (fees.containsKey(FeeType.SEBI)) {
      FeeModel sebiFees = fees[FeeType.SEBI][tradeType] as FeeModel;
      response.sebi = (response.buyTransactionAmount * sebiFees.percent / 100) +
          (response.sellTransactionAmount * sebiFees.percent / 100);
    }
    // Stamp Duty
    if (fees.containsKey(FeeType.STAMP_DUTY)) {
      BuySellModel stampdutyFees =
          fees[FeeType.STAMP_DUTY][tradeType] as BuySellModel;
      response.stampduty = (response.buyTransactionAmount *
              stampdutyFees.buy.percent /
              100) +
          (response.sellTransactionAmount * stampdutyFees.sell.percent / 100);
    }

    if (sellPrice.isNotEmpty() && buyPrice.isNotEmpty()) {
      response.profitOrLoss = response.sellTransactionAmount -
          response.buyTransactionAmount -
          response.totalTaxesAndCharges;
    }
    return response;
  }

  Map<String, dynamic> toJson() {
    return {
      'tradingOption': tradeType.label,
      'tradeExchange': exchange.name,
      'accountEntity': account.toJson(),
      'buyPrice': buyPrice.toStringSafe(),
      'sellPrice': sellPrice.toStringSafe(),
      'quantity': quantity.toStringSafe(),
      'amount': amount.toStringSafe(),
      'fees': fees.toString(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
