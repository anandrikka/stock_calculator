import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockcalculator/models/calculate_request_model.dart';
import 'package:stockcalculator/models/calculate_response_model.dart';
import 'package:stockcalculator/utils/constants.dart';
import 'package:stockcalculator/utils/enums.dart';

class CalculateResults extends StatefulWidget {
  final CalculateRequestModel inputs;
  final bool show;

  CalculateResults({this.inputs, this.show});

  @override
  _CalculateResultsState createState() => _CalculateResultsState();
}

class _CalculateResultsState extends State<CalculateResults> {
  bool hideDetailedCharges = true;

  @override
  Widget build(BuildContext context) {
    if (!widget.show) {
      return SizedBox();
    }
    CalculateResponseModel response = widget.inputs.calculationResult;
    return Column(
      children: [
        if (response.buyTransactionAmount.isNotEmpty() &&
            response.sellTransactionAmount.isNotEmpty())
          _buildProfitOrLossRow(
            context: context,
            response: response,
          ),
        if (response.buyTransactionAmount.isNotEmpty())
          _breakEvenRow(
            context: context,
            response: response,
          ),
        _buildRow(
          label: 'Transaction Amount',
          amount: response.transactionAmount,
        ),
        _buildTotalTaxesRow(context, response),
        if (!hideDetailedCharges) ...[
          _buildRow(
            label: 'Brokerage',
            amount: response.brokerage,
            padding: EdgeInsets.only(
              left: 8.0,
            ),
          ),
          _buildRow(
            label: 'SST / CST',
            amount: response.sst,
            padding: EdgeInsets.only(
              left: 8.0,
            ),
          ),
          _buildRow(
            label: 'Exchange Charges',
            amount: response.exchange,
            padding: EdgeInsets.only(
              left: 8.0,
            ),
          ),
          _buildRow(
            label: 'GST',
            amount: response.gst,
            padding: EdgeInsets.only(
              left: 8.0,
            ),
          ),
          _buildRow(
            label: 'SEBI',
            amount: response.sebi,
            padding: EdgeInsets.only(
              left: 8.0,
            ),
          ),
          _buildRow(
            label: 'Stampduty',
            amount: response.stampduty,
            padding: EdgeInsets.only(
              left: 8.0,
            ),
          ),
        ]
      ],
    );
  }

  _buildTotalTaxesRow(BuildContext context, CalculateResponseModel response) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          setState(() {
            hideDetailedCharges = !hideDetailedCharges;
          });
        },
        child: Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Total Taxes & Charges',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    !hideDetailedCharges
                        ? Transform.rotate(
                            angle: pi / 2,
                            child: Icon(
                              Icons.chevron_right,
                            ),
                          )
                        : Icon(
                            Icons.chevron_right,
                          ),
                  ],
                ),
              ),
              _amountText(response.totalTaxesAndCharges, width: 150),
            ],
          ),
        ),
      ),
      Divider(
        height: 1,
        // color: Theme.of(context).accentColor,
      ),
    ]);
  }

  _breakEvenRow({
    BuildContext context,
    CalculateResponseModel response,
  }) {
    return Column(
      children: [
        Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Breakeven Points',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Profit/Loss Error Margin = +/- 10₹',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                  ],
                ),
              ),
              _amountText(
                response.breakEvenPoints,
                width: 150,
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }

  _buildRow({
    String label,
    double amount,
    Widget divider = const Divider(
      height: 1.0,
    ),
    EdgeInsets padding = const EdgeInsets.all(0.0),
  }) {
    return Column(
      children: [
        Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLabelText(label, padding: padding),
              _amountText(amount),
            ],
          ),
        ),
        divider,
      ],
    );
  }

  _buildProfitOrLossRow({
    BuildContext context,
    CalculateResponseModel response,
  }) {
    Color color = response.profitOrLoss > 0 ? Colors.green : Colors.red;
    return Column(
      children: [
        Container(
          height: 45,
          alignment: Alignment.center,
          child: Row(
            children: [
              _buildLabelText(response.profitOrLoss > 0 ? 'Profit' : 'Loss'),
              Container(
                height: 45,
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width / 3,
                color: color,
                padding: EdgeInsets.only(right: 4.0),
                child: _amountText(
                  response.profitOrLoss,
                  style: TextStyle(
                    fontFamily: Constants.FIXED_FONT,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 2,
          color: color,
        )
      ],
    );
  }
}

_buildLabelText(
  label, {
  EdgeInsets padding = const EdgeInsets.all(0.0),
}) {
  return Expanded(
    child: Container(
      padding: padding,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    ),
  );
}

_amountText(
  double amount, {
  double width = 200,
  TextStyle style = const TextStyle(
    fontSize: 16,
    fontFamily: Constants.FIXED_FONT,
  ),
}) {
  return SizedBox(
    width: width,
    child: Text(
      '${amount.toStringAsFixed(2)}₹',
      textAlign: TextAlign.right,
      style: style,
    ),
  );
}
