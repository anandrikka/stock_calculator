import 'package:flutter/material.dart';
import 'package:stock_calculator/utils/constants.dart';
import 'package:stock_calculator/utils/enums.dart';
import 'package:stock_calculator/widgets/common/radio_button.dart';

class ChooseTradingOption extends StatefulWidget {
  final TradingOption selectedValue;

  ChooseTradingOption({this.selectedValue = TradingOption.EQUITY_DELIVERY});

  @override
  _ChooseTradingOptionState createState() => _ChooseTradingOptionState();
}

class _ChooseTradingOptionState extends State<ChooseTradingOption> {
  TradingOption selectedValue;
  List<dynamic> _tradingOptions = [];

  @override
  initState() {
    selectedValue = widget.selectedValue;
    var groups = TradingOption.values.map((v) => v.group).toSet();
    groups.forEach((group) {
      _tradingOptions.add({'label': group.capitalize(), 'header': true});
      TradingOption.values.where((to) => group == to.group).forEach((to) {
        _tradingOptions.add({
          'label': to.typeLabel,
          'value': to,
          'header': false,
        });
      });
    });
    // var groups = TradingOption.values.map((v) => v.group).toSet();
    // var types = TradingOption.values.map((v) => v.type).toSet();
    // print(groups);
    // print(types);
    super.initState();
  }

  selectOption(val) {
    setState(() {
      selectedValue = val;
    });
  }

  Widget getHeader(String title) {
    return Container(
      color: Constants.BG_COLOR,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          backgroundColor: Color.fromRGBO(240, 240, 240, 1),
          fontWeight: FontWeight.w500,
          fontFamily: Constants.HEADING_FONT,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(8.0),
      scrollable: true,
      titlePadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      titleTextStyle: Theme.of(context).textTheme.headline6.copyWith(
            fontSize: 16,
          ),
      title: Text(
        'Choose Account',
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: MediaQuery.of(context).size.width * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(8.0),
          child: ListBody(
            children: _tradingOptions.map<Widget>(
              (item) {
                if (item['header']) {
                  return getHeader(item['label']);
                }
                return RadioButton<TradingOption>(
                  label: item['label'],
                  groupValue: selectedValue,
                  value: item['value'],
                  onChanged: selectOption,
                );
              },
            ).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Theme.of(context).errorColor,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, selectedValue);
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, selectedValue);
          },
        ),
      ],
    );
  }
}
