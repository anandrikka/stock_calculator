import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_calculator/providers/fee_config_provider.dart';
import 'package:stock_calculator/widgets/settings/buy_and_sell_fee.dart';

class DefaultFeesPage extends StatelessWidget {
  final String title;

  DefaultFeesPage({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          title,
        ),
      ),
      body: Consumer<FeeConfigProvider>(
        builder: (_c, feeConfig, _w) {
          return BuyAndSellFee();
        },
      ),
    );
  }
}
