import 'package:flutter/material.dart';
import 'package:stockcalculator/utils/constants.dart';
import 'package:stockcalculator/widgets/settings/settings_page_list_item.dart';
import 'package:stockcalculator/widgets/settings/trading_option_fee_item.dart';

class TradingOptionFees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        ' ',
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    width: MediaQuery.of(context).size.width / 4,
                    child: Text(
                      'BUY',
                      style: TextStyle(
                          // color: Theme.of(context).accentColor,
                          ),
                    ),
                    alignment: Alignment.center,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    width: MediaQuery.of(context).size.width / 4,
                    child: Text(
                      'SELL',
                      style: TextStyle(
                          // color: Theme.of(context).accentColor,
                          ),
                    ),
                    alignment: Alignment.center,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        'EQUITY',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: Constants.HEADING_FONT,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   margin:
                  //       EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  //   width: MediaQuery.of(context).size.width / 4,
                  //   child: Text(
                  //     'BUY',
                  //     style: TextStyle(
                  //         // color: Theme.of(context).accentColor,
                  //         ),
                  //   ),
                  //   alignment: Alignment.center,
                  // ),
                  // Container(
                  //   margin:
                  //       EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  //   width: MediaQuery.of(context).size.width / 4,
                  //   child: Text(
                  //     'SELL',
                  //     style: TextStyle(
                  //         // color: Theme.of(context).accentColor,
                  //         ),
                  //   ),
                  //   alignment: Alignment.center,
                  // )
                ],
              ),
            ),
          ],
        ),
        TradingOptionFeeItem(
          label: 'Delivery',
        ),
        TradingOptionFeeItem(
          label: 'Intraday',
        ),
        TradingOptionFeeItem(
          label: 'Options',
        ),
        TradingOptionFeeItem(
          label: 'Futures',
        ),
        SettingsPageListItem(header: true, title: 'CURRENCY'),
        TradingOptionFeeItem(
          label: 'Options',
        ),
        TradingOptionFeeItem(
          label: 'Futures',
        ),
        SettingsPageListItem(header: true, title: 'COMMODITIES'),
        TradingOptionFeeItem(
          label: 'Options',
        ),
        TradingOptionFeeItem(
          label: 'Futures',
        ),
      ],
    );
  }
}
