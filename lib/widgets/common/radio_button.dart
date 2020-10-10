import 'package:flutter/material.dart';

class RadioButton<T> extends StatelessWidget {
  final String label;
  final T value;
  final T groupValue;
  final Function onChanged;

  const RadioButton({
    @required this.label,
    @required this.value,
    @required this.onChanged,
    @required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Radio<T>(
            groupValue: groupValue,
            value: value,
            onChanged: (T newValue) {
              onChanged(newValue);
            },
          ),
          Text(label)
        ],
      ),
    );
  }
}
