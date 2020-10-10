import 'package:flutter/material.dart';
import 'package:stock_calculator/utils/enums.dart';
import 'package:stock_calculator/widgets/settings/exchange_fees.dart';

class ExchangeFeesScreen extends StatefulWidget {
  final String title;

  ExchangeFeesScreen({this.title});

  @override
  _ExchangeFeesPageState createState() => _ExchangeFeesPageState();
}

class _ExchangeFeesPageState extends State<ExchangeFeesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Exchange Fees'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'BSE'),
            Tab(text: 'NSE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExchangeFees(
            feeType: FeeType.EXCHANGE_TRANSACTION_TAX_BSE,
          ),
          ExchangeFees(
            feeType: FeeType.EXCHANGE_TRANSACTION_TAX_NSE,
          ),
        ],
      ),
    );
  }
}
