import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockcalculator/models/calculate_request_model.dart';
import 'package:stockcalculator/models/calculate_response_model.dart';
import 'package:stockcalculator/utils/constants.dart';
import 'package:stockcalculator/utils/enums.dart';

class CalculateResults extends StatefulWidget {
  final CalculateRequestModel inputs;
  final bool show;

  CalculateResults({
    this.inputs,
    this.show,
  });

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
    CalculateResponseModel response = widget.inputs.calculate();
    return Column(
      children: [
        _ChargesRow(
          label: 'Transaction Amount',
          amount: response.transactionAmount,
        ),
        if (response.buyTransactionAmount.isNotEmpty() &&
            response.sellTransactionAmount.isNotEmpty())
          _ChargesRow(
            label: response.profitOrLoss > 0 ? 'Profit' : 'Loss',
            amount: response.profitOrLoss,
            amountStyle: TextStyle(
              fontSize: 16.0,
              fontFamily: Constants.FIXED_FONT,
              color: response.profitOrLoss > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (response.buyTransactionAmount.isNotEmpty())
          _ChargesRow(
            label: 'Breakeven Points',
            amount: response.breakEvenPoints,
          ),
        Divider(
          height: 1,
        ),
        _ChargesRow(
          label: 'Brokerage',
          amount: response.brokerage,
        ),
        _ChargesRow(
          label: 'SST / CST',
          amount: response.sst,
        ),
        _ChargesRow(
          label: 'Exchange Charges',
          amount: response.exchange,
        ),
        _ChargesRow(
          label: 'GST',
          amount: response.gst,
        ),
        _ChargesRow(
          label: 'SEBI',
          amount: response.sebi,
        ),
        _ChargesRow(
          label: 'Stampduty',
          amount: response.stampduty,
        ),
        Divider(
          height: 1,
        ),
        _ChargesRow(
          label: 'Total Charges',
          labelStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          amount: response.totalTaxesAndCharges,
          amountStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: Constants.FIXED_FONT,
          ),
        ),
      ],
    );
  }
}

class _ChargesRow extends StatelessWidget {
  final String label;
  final double amount;
  final TextStyle amountStyle;
  final TextStyle labelStyle;

  _ChargesRow({
    this.label,
    this.amount,
    this.amountStyle = const TextStyle(
      fontSize: 16.0,
      fontFamily: Constants.FIXED_FONT,
    ),
    this.labelStyle = const TextStyle(
      fontSize: 16.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: labelStyle,
            ),
          ),
          SizedBox(
            width: 180,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '${amount.toStringAsFixed(2)} ₹',
                style: amountStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
