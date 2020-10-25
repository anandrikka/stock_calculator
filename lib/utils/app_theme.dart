import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockcalculator/utils/constants.dart';

class AppThemeData {
  static ThemeData getAppThemeData(BuildContext context) {
    return ThemeData(
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            centerTitle: true,
            textTheme: Theme.of(context).textTheme.copyWith(
                  headline6: TextStyle(
                    color: Colors.white,
                    fontFamily: Constants.HEADING_FONT,
                    fontSize: 16,
                  ),
                  bodyText2: TextStyle(
                    color: Colors.white,
                    fontFamily: Constants.HEADING_FONT,
                    fontSize: 16,
                  ),
                ),
          ),
      primarySwatch: Colors.indigo,
      accentColor: Colors.pink,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: Constants.DEFAULT_FONT,
      textTheme: Theme.of(context).textTheme.copyWith(
            headline1: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            headline2: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            headline3: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            headline4: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            headline5: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            headline6: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            subtitle1: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            subtitle2: TextStyle(
              fontFamily: Constants.HEADING_FONT,
            ),
            bodyText1: TextStyle(
                // fontSize: 18,
                // color: Colors.black87,
                ),
            bodyText2: TextStyle(
                // fontSize: 16,
                // color: Colors.black87,
                ),
          ),
    );
  }
}
