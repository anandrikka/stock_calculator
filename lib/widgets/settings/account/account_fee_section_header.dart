import 'package:flutter/material.dart';

class AccountFeeSectionHeader extends StatelessWidget {
  final String label;
  final bool toggle;

  AccountFeeSectionHeader({
    this.label,
    this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black12
              : Colors.white12,
        ),
        // color: Theme.of(context).brightness == Brightness.light
        //     ? Colors.black12
        //     : Colors.white12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Theme.of(context).accentColor,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 70,
            child: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
