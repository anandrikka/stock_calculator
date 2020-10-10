import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_calculator/utils/constants.dart';

class DummyView extends StatefulWidget {
  final String title;

  DummyView({this.title});

  @override
  _DummyViewState createState() => _DummyViewState();
}

class _DummyViewState extends State<DummyView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: Constants.HEADING_FONT),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text('NSE'),
            ),
            Tab(
              child: Text('BSE'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [Text('Dummy1'), Text('Dummy 2')],
      ),
    );
  }
}
