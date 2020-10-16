import 'dart:convert';

import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/models/calculate_response_model.dart';
import 'package:stockcalculator/models/fee_model.dart';
import 'package:stockcalculator/utils/enums.dart';

/// Notional Amount = (Strike Price * quantity) + (Buy Price * quantity) + (Sell Price * quantity)

class CalculateRequestModel {
  final TradingOption tradeType;
  final TradeExchange exchange;
  final AccountEntity account;
  final double buyPrice;
  final double sellPrice;
  double quantity;
  final Map<FeeType, Map<TradingOption, dynamic>> fees;
  double commodity;
  double strikePrice;
  double lotSize;

  CalculateRequestModel({
    this.tradeType,
    this.exchange,
    this.account,
    this.buyPrice,
    this.sellPrice,
    this.quantity,
    this.fees,
    this.commodity,
    this.strikePrice,
    this.lotSize,
  });

  CalculateResponseModel get calculationResult {
    CalculateResponseModel response = CalculateResponseModel();
    // transaction amount
    response.buyTransactionAmount = buyPrice * quantity;
    response.sellTransactionAmount = sellPrice * quantity;
    // Brokerage
    response.brokerage = _calcBrokerage(
      response.buyTransactionAmount,
      response.sellTransactionAmount,
      response,
    );
    // SST
    response.sst = _calcSstCharges(
      response.buyTransactionAmount,
      response.sellTransactionAmount,
      response,
    );
    // Exchange
    response.exchange = _calcExchange(
      response.transactionAmount,
      response,
    );
    // GST
    response.gst = _calcGST(
      response.brokerage,
      response.exchange,
      response,
    );
    // SEBI
    response.sebi = _calcSEBI(
      response.buyTransactionAmount,
      response.sellTransactionAmount,
      response,
    );
    // Stamp Duty
    response.stampduty = _calcStampduty(
      response.buyTransactionAmount,
      response.sellTransactionAmount,
      response,
    );
    if (sellPrice.isNotEmpty() && buyPrice.isNotEmpty()) {
      response.profitOrLoss = response.sellTransactionAmount -
          response.buyTransactionAmount -
          response.totalTaxesAndCharges;
    }
    double breakEvenPoints = _calcBrakeEvenPoints(response);
    print('Breakeven Points: ' + breakEvenPoints.toStringAsFixed(2));
    response.breakEvenPoints = breakEvenPoints;
    return response;
  }

  _calcBrokerage(
    double buyTxAmt,
    double sellTxAmt,
    CalculateResponseModel response,
  ) {
    FeeModel accountFee = account.fees[tradeType];
    double brokerage = 0.0;
    if (accountFee.flat) {
      if (buyTxAmt.isNotEmpty()) {
        brokerage += accountFee.flatRate;
      }
      if (sellTxAmt.isNotEmpty()) {
        brokerage += accountFee.flatRate;
      }
    } else {
      var buyBrokerage = buyTxAmt * accountFee.percent / 100;
      var sellBrokerage = sellTxAmt * accountFee.percent / 100;
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
      brokerage = buyBrokerage + sellBrokerage;
    }
    return brokerage;
  }

  _calcSstCharges(
    double buyTxAmt,
    double sellTxAmt,
    CalculateResponseModel response,
  ) {
    double sst = 0.0;
    if (fees.containsKey(FeeType.SECURITY_TRANSACTION_TAX)) {
      BuySellModel sstFees =
          fees[FeeType.SECURITY_TRANSACTION_TAX][tradeType] as BuySellModel;
      sst = (buyTxAmt * sstFees.buy.percent / 100) +
          (sellTxAmt * sstFees.sell.percent / 100);
    }
    return sst;
  }

  _calcExchange(
    double txAmt,
    CalculateResponseModel response,
  ) {
    FeeType exchangeFeeType = exchange == TradeExchange.BSE
        ? FeeType.EXCHANGE_TRANSACTION_TAX_BSE
        : FeeType.EXCHANGE_TRANSACTION_TAX_NSE;
    double exchangeFee = 0.0;
    if (fees.containsKey(exchangeFeeType)) {
      FeeModel exchangeFees = fees[exchangeFeeType][tradeType] as FeeModel;
      exchangeFee = txAmt * exchangeFees.percent / 100;
    }
    return exchangeFee;
  }

  _calcGST(
    double brokerage,
    double exchange,
    CalculateResponseModel response,
  ) {
    double gst = 0.0;
    if (fees.containsKey(FeeType.GST)) {
      FeeModel gstFees = fees[FeeType.GST][tradeType] as FeeModel;
      gst = (brokerage + exchange) * gstFees.percent / 100;
    }
    return gst;
  }

  _calcSEBI(
    double buyTxAmt,
    double sellTxAmt,
    CalculateResponseModel response,
  ) {
    double sebi = 0.0;
    if (fees.containsKey(FeeType.SEBI)) {
      FeeModel sebiFees = fees[FeeType.SEBI][tradeType] as FeeModel;
      sebi = (buyTxAmt * sebiFees.percent / 100) +
          (sellTxAmt * sebiFees.percent / 100);
    }
    return sebi;
  }

  _calcStampduty(
    double buyTxAmt,
    double sellTxAmt,
    CalculateResponseModel response,
  ) {
    double stampduty = 0.0;
    if (fees.containsKey(FeeType.STAMP_DUTY)) {
      BuySellModel stampdutyFees =
          fees[FeeType.STAMP_DUTY][tradeType] as BuySellModel;
      stampduty = (buyTxAmt * stampdutyFees.buy.percent / 100) +
          (sellTxAmt * stampdutyFees.sell.percent / 100);
    }
    return stampduty;
  }

  _calcBrakeEvenPoints(CalculateResponseModel response) {
    double step = 1;
    double buyTxAmt = buyPrice * quantity;
    double totalBuyCharges = _totalCharges(buyTxAmt, 0.0, response);
    double sellPrice = (totalBuyCharges + buyTxAmt) / quantity;
    while (true) {
      double sellTxAmt = sellPrice * quantity;
      double totalSellCharges = _totalCharges(0.0, sellTxAmt, response);
      double profitOrLoss =
          sellTxAmt - buyTxAmt - totalBuyCharges - totalSellCharges;
      if (profitOrLoss < -5) {
        sellPrice += step;
      } else if (profitOrLoss > 5) {
        step = step - (step / 10);
        sellPrice -= step;
      } else {
        break;
      }
    }
    return sellPrice - buyPrice;
  }

  _totalCharges(buyTxAmt, sellTxAmt, response) {
    double brokerage = _calcBrokerage(
      buyTxAmt,
      sellTxAmt,
      response,
    );
    // SST
    double sst = _calcSstCharges(
      buyTxAmt,
      sellTxAmt,
      response,
    );
    // Exchange
    double exchange = _calcExchange(
      buyTxAmt + sellTxAmt,
      response,
    );
    // GST
    double gst = _calcGST(
      brokerage,
      exchange,
      response,
    );
    // SEBI
    double sebi = _calcSEBI(
      buyTxAmt,
      sellTxAmt,
      response,
    );
    // Stamp Duty
    double stampduty = _calcStampduty(
      buyTxAmt,
      sellTxAmt,
      response,
    );
    double totalTaxes = brokerage + sst + exchange + gst + stampduty + sebi;
    return totalTaxes;
  }

  Map<String, dynamic> toJson() {
    return {
      'tradingOption': tradeType.label,
      'tradeExchange': exchange.name,
      'accountEntity': account.toJson(),
      'buyPrice': buyPrice.toStringSafe(),
      'sellPrice': sellPrice.toStringSafe(),
      'quantity': quantity.toStringSafe(),
      'fees': fees.toString(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
