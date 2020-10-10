class FeeModel {
  final double percent;
  final double min;
  final double max;
  final bool flat;
  final double flatRate;
  FeeModel({
    this.percent = 0.0,
    this.min = 0.0,
    this.max = 0.0,
    this.flat = false,
    this.flatRate = 0.0,
  });

  bool get hasNoFee =>
      (flat && flatRate == 0.0) ||
      (!flat && percent == 0.0 && min == 0.0 && max == 0.0);

  Map<String, dynamic> toJson() => {
        'percent': this.percent,
        'min': this.min,
        'max': this.max,
        'flat': this.flat,
        'flatRate': this.flatRate
      };

  FeeModel.fromJson(Map<String, dynamic> json)
      : percent = json['percent'] as double,
        min = json['min'] as double,
        max = json['max'] as double,
        flat = json['flat'] as bool,
        flatRate = json['flatRate'] as double;
}

class BuySellModel {
  FeeModel buy;
  FeeModel sell;

  BuySellModel();

  Map<String, dynamic> toJson() => {
        'buy': buy.toJson(),
        'sell': sell.toJson(),
      };
  BuySellModel.fromJson(Map<String, dynamic> json)
      : buy = FeeModel.fromJson(json['buy']),
        sell = FeeModel.fromJson(json['sell']);
}
