import 'dart:convert';

import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/models/account_fee_model.dart';
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
  double gst;

  CalculateRequestModel({
    this.tradeType,
    this.exchange,
    this.account,
    this.buyPrice,
    this.sellPrice,
    this.quantity,
    this.fees,
    this.commodity,
    this.strikePrice = 0.0,
    this.lotSize,
    this.gst,
  });

  double get strikeTxBuyAmt => strikePrice * lotSize * quantity;
  double get strikeTxSellAmt => strikePrice * lotSize * quantity;
  double get buyTxAmt => buyPrice * lotSize * quantity;
  double get sellTxAmt => sellPrice * lotSize * quantity;
  double get txAmt => buyTxAmt + sellTxAmt;
  double get strikeTxAmt => strikeTxBuyAmt + strikeTxSellAmt;
  double get dpCharges {
    double charges = 0.0;
    if (account.dpFee > 0) {
      charges = account.dpFee + (account.dpFee * gst * 0.01);
    }
    return charges;
  }

  CalculateResponseModel calculate() {
    CalculateResponseModel response = CalculateResponseModel();

    response.strikeTxAmt = strikeTxBuyAmt;
    response.buyTransactionAmount = buyTxAmt;
    response.sellTransactionAmount = sellTxAmt;

    // Calculate Brokerage
    response.brokerage = calculateBrokerage(
        strikeTxBuyAmt + buyTxAmt, strikeTxSellAmt + sellTxAmt);

    // Calculate STT
    response.sst = calculateSTT(buyTxAmt, sellTxAmt);

    // Calculate Exchange
    response.exchange = calculateExchange(buyTxAmt + sellTxAmt);

    // Calculate GST
    response.gst = calculateGST(response.brokerage, response.exchange);

    // Calculate SEBI
    response.sebi = calculateSEBI(buyTxAmt + sellTxAmt);

    // Calculate StampDuty
    response.stampduty = calculateStampduty(buyTxAmt, sellTxAmt);

    // Calculate Profit/Loss
    if (sellPrice.isNotEmpty() && buyPrice.isNotEmpty()) {
      response.profitOrLoss = response.sellTransactionAmount -
          response.buyTransactionAmount -
          response.totalTaxesAndCharges;
    }

    if (tradeType == TradingOption.EQUITY_DELIVERY && sellTxAmt > 0) {
      response.dp = dpCharges;
    }

    response.breakEvenPoints = calculateBreakEven();

    return response;
  }

  double calculateBrokerage(double buyTxAmt, double sellTxAmt) {
    AccountFeeModel accountFee = account.fees[tradeType];
    double brokerage = 0.0;
    if (accountFee.isFlat) {
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

  double calculateSTT(double buyTxAmt, double sellTxAmt) {
    double sst = 0.0;
    if (fees.containsKey(FeeType.SECURITY_TRANSACTION_TAX)) {
      BuySellModel sstFees =
          fees[FeeType.SECURITY_TRANSACTION_TAX][tradeType] as BuySellModel;
      sst = (buyTxAmt * sstFees.buy.percent / 100) +
          (sellTxAmt * sstFees.sell.percent / 100);
    }
    return sst;
  }

  double calculateExchange(double txAmt) {
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

  double calculateClearingFee(double txAmt) {
    ClearingFee clearingFee = account.fees[tradeType].clearingFee;
    if (exchange == TradeExchange.BSE) {
      return clearingFee.bse * txAmt * 0.01;
    }
    return clearingFee.nse * txAmt * 0.01;
  }

  double calculateGST(double brokerage, double exchange) {
    return (brokerage + exchange) * gst * 1 / 100;
  }

  double calculateSEBI(double txAmt) {
    double sebi = 0.0;
    FeeModel sebiFees = fees[FeeType.SEBI][tradeType] as FeeModel;
    sebi = (txAmt * sebiFees.percent / 100);
    return sebi;
  }

  double calculateStampduty(double buyTxAmt, double sellTxAmt) {
    double stampduty = 0.0;
    if (fees.containsKey(FeeType.STAMP_DUTY)) {
      BuySellModel stampdutyFees =
          fees[FeeType.STAMP_DUTY][tradeType] as BuySellModel;
      stampduty = (buyTxAmt * stampdutyFees.buy.percent / 100) +
          (sellTxAmt * stampdutyFees.sell.percent / 100);
    }
    return stampduty;
  }

  double calculateTotalCharges(
    double buyTxAmt,
    double sellTxAmt, {
    double strikeTxBuyAmt = 0.0,
    double strikeTxSellAmt = 0.0,
  }) {
    double brokerage = calculateBrokerage(
        strikeTxBuyAmt + buyTxAmt, strikeTxSellAmt + sellTxAmt);
    double sst = calculateSTT(buyTxAmt, sellTxAmt);
    double exchange = calculateExchange(buyTxAmt + sellTxAmt);
    double gst = calculateGST(brokerage, exchange);
    double stampduty = calculateStampduty(buyTxAmt, sellTxAmt);
    double sebi = calculateSEBI(buyTxAmt + sellTxAmt);
    // double clearingFee = calculateClearingFee(buyTxAmt + sellTxAmt);
    double totalCharges = brokerage + sst + exchange + gst + stampduty + sebi;
    if (tradeType == TradingOption.EQUITY_DELIVERY && sellTxAmt > 0) {
      totalCharges = totalCharges + dpCharges;
    }
    return totalCharges;
  }

  double calculateBreakEven() {
    double step = 1;
    double totalBuyCharges = calculateTotalCharges(
      buyTxAmt,
      0.0,
      strikeTxBuyAmt: strikeTxBuyAmt,
    );
    double sellPrice = (totalBuyCharges + buyTxAmt) / (quantity * lotSize);
    // double dp = 0.0;
    // if (tradeType == TradingOption.EQUITY_DELIVERY) {
    //   dp = dpCharges;
    // }
    int iterations = 0;
    while (true) {
      iterations++;
      if (iterations > 100000) {
        break;
      }
      double sellTxAmt = sellPrice * lotSize * quantity;
      double totalSellCharges = calculateTotalCharges(0.0, sellTxAmt,
          strikeTxSellAmt: strikeTxSellAmt);
      double profitOrLoss =
          sellTxAmt - buyTxAmt - totalBuyCharges - totalSellCharges;
      if (profitOrLoss < -5) {
        sellPrice += step;
      } else if (profitOrLoss > 5) {
        step -= step / 100;
        sellPrice -= step;
      } else {
        break;
      }
    }
    return sellPrice - buyPrice;
  }

  // CalculateResponseModel get calculationResult {
  //   CalculateResponseModel response = CalculateResponseModel();
  //   // transaction amount
  //   if (tradeType.isOptions) {
  //     response.strikeTxBuyAmount = strikePrice * lotSize * quantity;
  //     response.strikeTxSellAmount = strikePrice * lotSize * quantity;
  //     response.buyTransactionAmount = buyPrice * lotSize * quantity;
  //     response.sellTransactionAmount = sellPrice * lotSize * quantity;
  //   } else {
  //     response.buyTransactionAmount = buyPrice * quantity;
  //     response.sellTransactionAmount = sellPrice * quantity;
  //   }
  //   // Brokerage
  //   if (tradeType.isOptions) {
  //     response.brokerage = _calcBrokerage(
  //       response.strikeTxBuyAmount + response.buyTransactionAmount,
  //       response.strikeTxSellAmount + response.sellTransactionAmount,
  //       response,
  //     );
  //   } else {
  //     response.brokerage = _calcBrokerage(
  //       response.buyTransactionAmount,
  //       response.sellTransactionAmount,
  //       response,
  //     );
  //   }
  //   // SST
  //   response.sst = _calcSstCharges(
  //     response.buyTransactionAmount,
  //     response.sellTransactionAmount,
  //     response,
  //   );
  //   // Exchange
  //   response.exchange = _calcExchange(
  //     response.transactionAmount,
  //     response,
  //   );
  //   // GST
  //   response.gst = _calcGST(
  //     response.brokerage,
  //     response.exchange,
  //     response,
  //   );
  //   // SEBI
  //   response.sebi = _calcSEBI(
  //     response.buyTransactionAmount,
  //     response.sellTransactionAmount,
  //     response,
  //   );
  //   // Stamp Duty
  //   response.stampduty = _calcStampduty(
  //     response.buyTransactionAmount,
  //     response.sellTransactionAmount,
  //     response,
  //   );
  //   if (sellPrice.isNotEmpty() && buyPrice.isNotEmpty()) {
  //     response.profitOrLoss = response.sellTransactionAmount -
  //         response.buyTransactionAmount -
  //         response.totalTaxesAndCharges;
  //   }
  //   double breakEvenPoints = _calcBrakeEvenPoints(response);
  //   print('Breakeven Points: ' + breakEvenPoints.toStringAsFixed(2));
  //   response.breakEvenPoints = breakEvenPoints;
  //   return response;
  // }
  //
  // _calcBrokerage(
  //   double buyTxAmt,
  //   double sellTxAmt,
  //   CalculateResponseModel response,
  // ) {
  //   AccountFeeModel accountFee = account.fees[tradeType];
  //   double brokerage = 0.0;
  //   if (accountFee.isFlat) {
  //     if (buyTxAmt.isNotEmpty()) {
  //       brokerage += accountFee.flatRate;
  //     }
  //     if (sellTxAmt.isNotEmpty()) {
  //       brokerage += accountFee.flatRate;
  //     }
  //   } else {
  //     var buyBrokerage = buyTxAmt * accountFee.percent / 100;
  //     var sellBrokerage = sellTxAmt * accountFee.percent / 100;
  //     if (accountFee.min.isNotEmpty() && buyBrokerage < accountFee.min) {
  //       buyBrokerage = accountFee.min;
  //     }
  //     if (accountFee.min.isNotEmpty() && sellBrokerage < accountFee.min) {
  //       sellBrokerage = accountFee.min;
  //     }
  //     if (accountFee.max.isNotEmpty() && buyBrokerage > accountFee.max) {
  //       buyBrokerage = accountFee.max;
  //     }
  //     if (accountFee.max.isNotEmpty() && sellBrokerage > accountFee.max) {
  //       sellBrokerage = accountFee.max;
  //     }
  //     brokerage = buyBrokerage + sellBrokerage;
  //   }
  //   return brokerage;
  // }
  //
  // _calcSstCharges(
  //   double buyTxAmt,
  //   double sellTxAmt,
  //   CalculateResponseModel response,
  // ) {
  //   double sst = 0.0;
  //   if (fees.containsKey(FeeType.SECURITY_TRANSACTION_TAX)) {
  //     BuySellModel sstFees =
  //         fees[FeeType.SECURITY_TRANSACTION_TAX][tradeType] as BuySellModel;
  //     sst = (buyTxAmt * sstFees.buy.percent / 100) +
  //         (sellTxAmt * sstFees.sell.percent / 100);
  //   }
  //   return sst;
  // }
  //
  // _calcExchange(
  //   double txAmt,
  //   CalculateResponseModel response,
  // ) {
  //   FeeType exchangeFeeType = exchange == TradeExchange.BSE
  //       ? FeeType.EXCHANGE_TRANSACTION_TAX_BSE
  //       : FeeType.EXCHANGE_TRANSACTION_TAX_NSE;
  //   double exchangeFee = 0.0;
  //   if (fees.containsKey(exchangeFeeType)) {
  //     FeeModel exchangeFees = fees[exchangeFeeType][tradeType] as FeeModel;
  //     exchangeFee = txAmt * exchangeFees.percent / 100;
  //   }
  //   return exchangeFee;
  // }
  //
  // _calcGST(
  //   double brokerage,
  //   double exchange,
  //   CalculateResponseModel response,
  // ) {
  //   return (brokerage + exchange) * gst * 1 / 100;
  // }
  //
  // _calcSEBI(
  //   double buyTxAmt,
  //   double sellTxAmt,
  //   CalculateResponseModel response,
  // ) {
  //   double sebi = 0.0;
  //   if (fees.containsKey(FeeType.SEBI)) {
  //     FeeModel sebiFees = fees[FeeType.SEBI][tradeType] as FeeModel;
  //     sebi = (buyTxAmt * sebiFees.percent / 100) +
  //         (sellTxAmt * sebiFees.percent / 100);
  //   }
  //   return sebi;
  // }
  //
  // _calcStampduty(
  //   double buyTxAmt,
  //   double sellTxAmt,
  //   CalculateResponseModel response,
  // ) {
  //   double stampduty = 0.0;
  //   if (fees.containsKey(FeeType.STAMP_DUTY)) {
  //     BuySellModel stampdutyFees =
  //         fees[FeeType.STAMP_DUTY][tradeType] as BuySellModel;
  //     stampduty = (buyTxAmt * stampdutyFees.buy.percent / 100) +
  //         (sellTxAmt * stampdutyFees.sell.percent / 100);
  //   }
  //   return stampduty;
  // }
  //
  // _calcBrakeEvenPoints(CalculateResponseModel response) {
  //   double step = 1;
  //   double buyTxAmt = buyPrice * quantity;
  //   double totalBuyCharges = _totalCharges(buyTxAmt, 0.0, response);
  //   double sellPrice = (totalBuyCharges + buyTxAmt) / quantity;
  //   while (true) {
  //     double sellTxAmt = sellPrice * quantity;
  //     double totalSellCharges = _totalCharges(0.0, sellTxAmt, response);
  //     double profitOrLoss =
  //         sellTxAmt - buyTxAmt - totalBuyCharges - totalSellCharges;
  //     if (profitOrLoss < -5) {
  //       sellPrice += step;
  //     } else if (profitOrLoss > 5) {
  //       step = step - (step / 100);
  //       sellPrice -= step;
  //     } else {
  //       break;
  //     }
  //   }
  //   return sellPrice - buyPrice;
  // }
  //
  // _totalCharges(buyTxAmt, sellTxAmt, response) {
  //   double brokerage = _calcBrokerage(
  //     buyTxAmt,
  //     sellTxAmt,
  //     response,
  //   );
  //   // SST
  //   double sst = _calcSstCharges(
  //     buyTxAmt,
  //     sellTxAmt,
  //     response,
  //   );
  //   // Exchange
  //   double exchange = _calcExchange(
  //     buyTxAmt + sellTxAmt,
  //     response,
  //   );
  //   // GST
  //   double gst = _calcGST(
  //     brokerage,
  //     exchange,
  //     response,
  //   );
  //   // SEBI
  //   double sebi = _calcSEBI(
  //     buyTxAmt,
  //     sellTxAmt,
  //     response,
  //   );
  //   // Stamp Duty
  //   double stampduty = _calcStampduty(
  //     buyTxAmt,
  //     sellTxAmt,
  //     response,
  //   );
  //   double totalTaxes = brokerage + sst + exchange + gst + stampduty + sebi;
  //   return totalTaxes;
  // }

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
