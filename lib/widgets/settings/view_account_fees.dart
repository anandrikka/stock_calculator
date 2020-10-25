import 'package:flutter/material.dart';
import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/models/option.dart';
import 'package:stockcalculator/utils/enum_lists.dart';
import 'package:stockcalculator/utils/enums.dart';

class ViewAccountFees extends StatelessWidget {
  final AccountEntity accountEntity;

  ViewAccountFees({this.accountEntity});

  @override
  Widget build(BuildContext context) {
    List<Option<TradingOption>> options = EnumsAsList.getTradingOptions();
    return ListView(
      children: options
          .map<List<Widget>>(
            (option) {
              var fee = accountEntity.fees[option.value];
              return [
                // Container(
                //   margin: EdgeInsets.only(top: 20.0),
                //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Text(
                //     option.label,
                //     style: TextStyle(
                //       color: Theme.of(context).accentColor,
                //     ),
                //   ),
                // ),
                ListTile(
                  dense: true,
                  title: Text(
                    option.label,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                if (fee.hasNoFee)
                  ListTile(
                    // dense: true,
                    title: Text(
                      'No Fee Applicable',
                    ),
                  )
                else if (fee.flatFee.flag)
                  ListTile(
                    // dense: true,
                    title: Text('Flat Rate'),
                    trailing: SizedBox(
                      width: 75.0,
                      child: Text(
                        '${fee.flatRate.toString()} ₹',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  )
                else ...[
                  ListTile(
                    title: Text('Percent'),
                    trailing: SizedBox(
                      width: 75.0,
                      child: Text(
                        '${fee.percent.toString()} %',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Minimum Fee'),
                    trailing: SizedBox(
                      width: 75.0,
                      child: Text(
                        '${fee.min.toString()} ₹',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Maximum Fee'),
                    trailing: SizedBox(
                      width: 75.0,
                      child: Text(
                        '${fee.max.toString()} ₹',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  )
                ]
              ];
            },
          )
          .expand((item) => item)
          .toList(),
    );
  }
}
