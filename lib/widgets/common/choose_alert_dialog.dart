import 'package:flutter/material.dart';
import 'package:stockcalculator/models/option.dart';

class ChooseAlertDialog<T> extends StatelessWidget {
  final List<Option<T>> options;
  final T value;
  final String title;
  final double heightFactor;

  ChooseAlertDialog({
    this.options,
    this.value,
    this.title,
    this.heightFactor = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.all(0.0),
      titlePadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      // titleTextStyle: Theme.of(context).textTheme.headline6.copyWith(
      //       fontSize: 16,
      //     ),
      content: Container(
        height: MediaQuery.of(context).size.height * heightFactor,
        width: MediaQuery.of(context).size.width * 0.85,
        child: ListView.separated(
          itemBuilder: (_, index) {
            Option<T> option = options[index];
            return RadioListTile(
              dense: true,
              groupValue: value,
              value: option.value,
              title: Text(option.label),
              onChanged: (T value) => Navigator.pop(context, value),
            );
          },
          separatorBuilder: (_, __) => Divider(
            height: 2.0,
          ),
          itemCount: options.length,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
