class CalculateResponseModel {
  double buyTransactionAmount = 0.0;
  double sellTransactionAmount = 0.0;
  double strikeTxAmt = 0.0;
  double profitOrLoss = 0.0;
  double brokerage = 0.0;
  double sst = 0.0;
  double exchange = 0.0;
  double gst = 0.0;
  double stampduty = 0.0;
  double sebi = 0.0;
  double breakEvenPoints = 0.0;
  double dp = 0.0;

  double get transactionAmount => buyTransactionAmount + sellTransactionAmount;

  double get totalTaxesAndCharges =>
      brokerage + sst + exchange + gst + stampduty + sebi + dp;

  Map<String, dynamic> toJson() {
    return {
      'transactionAmount': transactionAmount,
      'brokerage': brokerage,
      'sst': sst,
      'exchange': exchange,
      'gst': gst,
      'sebi': sebi,
      'stampduty': stampduty,
      'dp': dp,
      'totalTaxesAndCharges': totalTaxesAndCharges
    };
  }

  CalculateResponseModel();

  @override
  String toString() {
    return toJson().toString();
  }
}
