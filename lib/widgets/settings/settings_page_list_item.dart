import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_calculator/utils/constants.dart';

enum SettingsPageSuffixType { More, Toggle, Nothing }

// ignore: must_be_immutable
class SettingsPageListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onClick;
  final double height;
  final SettingsPageSuffixType suffixType;
  final bool header;
  Color iconColor;
  final bool toggle;

  final colors = [
    Colors.pink,
    // Colors.pinkAccent,
    Colors.purple,
    // Colors.deepPurpleAccent,
    Colors.indigo,
    // Colors.indigoAccent,
    Colors.blue,
    // Colors.blueAccent,
    Colors.teal,
    Colors.orange,
    // Colors.orangeAccent,
    Colors.deepOrange,
    // Colors.deepOrangeAccent
  ];

  SettingsPageListItem({
    @required this.title,
    this.subtitle = '',
    this.icon,
    this.onClick,
    this.height = 40,
    this.suffixType = SettingsPageSuffixType.More,
    this.header = false,
    this.toggle = false,
  }) {
    this.iconColor = colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    if (header) {
      return _SettingsPageListHeader(title);
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (null != onClick) onClick();
          },
          child: SafeArea(
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              // decoration: BoxDecoration(
              //     // color: Colors.white,
              //     // border: Border(
              //     //   bottom: BorderSide(color: Colors.grey, width: 0.4),
              //     // ),
              //     ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 50,
                    child: Icon(
                      icon,
                      color: iconColor,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        if (null != subtitle && subtitle.isNotEmpty)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                subtitle,
                                style: Theme.of(context).textTheme.subtitle2,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 60,
                    child: suffixType == SettingsPageSuffixType.More
                        ? Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                        : suffixType == SettingsPageSuffixType.Toggle
                            ? Switch(
                                inactiveThumbColor:
                                    Theme.of(context).accentColor,
                                value: toggle,
                                onChanged: (_) {
                                  if (null != onClick) onClick();
                                },
                              )
                            : Text(''),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}

class _SettingsPageListHeader extends StatelessWidget {
  final String title;

  _SettingsPageListHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: Constants.HEADING_FONT,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
