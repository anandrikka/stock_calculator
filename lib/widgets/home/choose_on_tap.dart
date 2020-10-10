import 'dart:math';

import 'package:flutter/material.dart';

class ChooseOnTap extends StatelessWidget {
  final String label;
  final EdgeInsets margin;
  final String value;
  final Function onTap;

  ChooseOnTap({
    @required this.label,
    this.margin,
    @required this.value,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          Text(
            label,
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              height: 40,
              child: GestureDetector(
                onTap: onTap,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: Transform.rotate(
                        angle: pi / 2,
                        child: Icon(
                          Icons.chevron_right,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
