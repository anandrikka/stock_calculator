import 'dart:convert';

class AccountFeeModel {
  double percent;
  double min;
  double max;
  FlatFee flatFee = FlatFee();
  FeePerLot lotFee = FeePerLot();
  ClearingFee clearingFee = ClearingFee();

  AccountFeeModel({
    this.percent = 0.0,
    this.min = 0.0,
    this.max = 0.0,
    ClearingFee clearingFee,
    FlatFee flatFee,
  }) {
    if (null != clearingFee) {
      this.clearingFee = clearingFee;
    }
    if (null != flatFee) {
      this.flatFee = flatFee;
    }
    if (null != lotFee) {
      this.lotFee = lotFee;
    }
  }
  bool get isFlat => flatFee.flag;
  double get flatRate => flatFee.rate;
  bool get isPerLot => lotFee.flag;
  double get lotRate => lotFee.rate;
  bool get hasNoFee =>
      (isFlat && flatRate == 0.0) ||
      (isPerLot && lotRate == 0.0) ||
      (!isFlat && !isPerLot && percent == 0.0 && min == 0.0 && max == 0.0);

  Map<String, dynamic> toJson() => {
        'percent': this.percent,
        'min': this.min,
        'max': this.max,
        'flatFee': this.flatFee.toJson(),
        'clearingFee': this.clearingFee.toJson(),
        'lotFee': this.lotFee.toJson(),
      };

  AccountFeeModel.fromJson(Map<String, dynamic> json)
      : percent = json['percent'] as double,
        min = json['min'] as double,
        max = json['max'] as double,
        flatFee = FlatFee.fromJson(json['flatFee']),
        lotFee = FeePerLot.fromJson(json['lotFee']),
        clearingFee = ClearingFee.fromJson(json['clearingFee']);
}

class ClearingFee {
  double nse;
  double bse;
  bool flag;

  ClearingFee({
    this.nse = 0.0,
    this.bse = 0.0,
    this.flag = false,
  });

  Map<String, dynamic> toJson() {
    return {'NSE': nse, 'BSE': bse, 'flag': flag};
  }

  ClearingFee.fromJson(Map<String, dynamic> json)
      : bse = json['BSE'] as double,
        nse = json['NSE'] as double,
        flag = json['flag'] as bool;

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class FlatFee {
  bool flag;
  double rate;

  FlatFee({
    this.flag = false,
    this.rate = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {'flag': flag, 'rate': this.rate};
  }

  FlatFee.fromJson(Map<String, dynamic> json)
      : flag = json['flag'] as bool,
        rate = json['rate'] as double;

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class FeePerLot {
  bool flag;
  double rate;

  FeePerLot({
    this.flag = false,
    this.rate = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {'flag': flag, 'rate': this.rate};
  }

  FeePerLot.fromJson(Map<String, dynamic> json)
      : flag = json['flag'] as bool,
        rate = json['rate'] as double;

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
