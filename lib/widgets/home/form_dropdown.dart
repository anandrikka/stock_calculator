import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stock_calculator/models/option.dart';

class FormDropdown extends StatelessWidget {
  final String value;
  final List<Option<String>> options;
  final bool loading;
  final Function onChanged;

  FormDropdown({
    this.value,
    this.options,
    this.loading,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      // padding: EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        itemHeight: 50,
        underline: Container(
          height: 0,
        ),
        icon: Container(
          child: loading
              ? SizedBox(
                  width: 24.0,
                  height: 20.0,
                  child: Container(
                    margin: EdgeInsets.only(right: 4.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : Transform.rotate(
                  angle: pi / 2,
                  child: Icon(Icons.chevron_right),
                ),
        ),
        iconSize: 24,
        elevation: 16,
        onChanged: onChanged,
        items: options
            .map(
              (e) => DropdownMenuItem<String>(
                value: e.value,
                child: Text(e.label),
              ),
            )
            .toList(),
        selectedItemBuilder: (BuildContext _) {
          return options
              .map(
                (e) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
                  child: Text(e.label),
                ),
              )
              .toList();
        },
      ),
    );
  }
}
