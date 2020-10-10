import 'package:flutter/material.dart';
import 'package:stock_calculator/utils/constants.dart';
import 'package:stock_calculator/widgets/common/radio_button.dart';

class SelectDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<SelectDialogOption<T>> options;
  final String title;
  final double heightFactor;

  SelectDialog({
    @required this.title,
    this.selectedValue,
    @required this.options,
    this.heightFactor = 0.6,
  });

  @override
  _SelectDialogState<T> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog> {
  T _selectedValue;
  List<SelectDialogOption<T>> _options;

  @override
  initState() {
    _selectedValue = widget.selectedValue;
    _options = widget.options;
    super.initState();
  }

  selectOption(T t) {
    setState(() {
      _selectedValue = t;
    });
  }

  Widget buildHeader(String title) {
    return Container(
      // color: Constants.BG_COLOR,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          // backgroundColor: Color.fromRGBO(240, 240, 240, 1),
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
        widget.title,
        // textAlign: TextAlign.center,
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * widget.heightFactor,
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(8.0),
          child: ListBody(
            children: _options.map<Widget>(
              (option) {
                if (option.isHeader) {
                  return buildHeader(option.label);
                }
                return RadioButton<T>(
                  label: option.label,
                  groupValue: _selectedValue,
                  value: option.value,
                  onChanged: selectOption,
                );
              },
            ).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          // textColor: Theme.of(context).errorColor,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, _selectedValue);
          },
        ),
      ],
    );
  }
}

class SelectDialogOption<T> {
  String label;
  bool isHeader;
  T value;

  SelectDialogOption({this.label, this.value, this.isHeader});
}
