import 'dart:convert';

class AccountFeeModel {
  final double percent;
  final double min;
  final double max;
  final bool flat;
  final double flatRate;
  ClearingFee clearingFee = ClearingFee();

  AccountFeeModel(
      {this.percent,
      this.min,
      this.max,
      this.flat,
      this.flatRate,
      ClearingFee clearingFee}) {
    this.clearingFee = clearingFee;
  }

  bool get hasNoFee =>
      (flat && flatRate == 0.0) ||
      (!flat && percent == 0.0 && min == 0.0 && max == 0.0);

  Map<String, dynamic> toJson() => {
        'percent': this.percent,
        'min': this.min,
        'max': this.max,
        'flat': this.flat,
        'flatRate': this.flatRate,
        'clearingFee': this.clearingFee.toJson(),
      };

  AccountFeeModel.fromJson(Map<String, dynamic> json)
      : percent = json['percent'] as double,
        min = json['min'] as double,
        max = json['max'] as double,
        flat = json['flat'] as bool,
        flatRate = json['flatRate'] as double,
        clearingFee = ClearingFee.fromJson(json['clearingFee']);
}

class ClearingFee {
  final double nse;
  final double bse;

  ClearingFee({this.nse = 0.0, this.bse = 0.0});

  Map<String, dynamic> toJson() {
    return {'NSE': nse, 'BSE': bse};
  }

  ClearingFee.fromJson(Map<String, dynamic> json)
      : bse = json['BSE'] as double,
        nse = json['NSE'] as double;

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
