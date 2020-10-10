import 'package:flutter/material.dart';
import 'package:stock_calculator/models/calculate_request_model.dart';
import 'package:stock_calculator/models/calculate_response_model.dart';
import 'package:stock_calculator/utils/constants.dart';
import 'package:stock_calculator/utils/enums.dart';

class CalculateResults extends StatelessWidget {
  final CalculateRequestModel inputs;
  final bool show;

  CalculateResults({this.inputs, this.show});

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return SizedBox();
    }
    CalculateResponseModel response = inputs.calculationResult;
    return Column(
      children: [
        if (response.buyTransactionAmount.isNotEmpty() &&
            response.sellTransactionAmount.isNotEmpty())
          _buildProfitOrLossRow(
            context: context,
            response: response,
          ),
        _buildRow(
          label: 'Transaction Amount',
          amount: response.transactionAmount,
        ),
        _buildRow(
          label: 'Total Taxes & Charges',
          amount: response.totalTaxesAndCharges,
        ),
        _buildRow(
          label: 'Brokerage',
          amount: response.brokerage,
        ),
        _buildRow(
          label: 'SST / CST',
          amount: response.sst,
        ),
        _buildRow(
          label: 'Exchange Charges',
          amount: response.exchange,
        ),
        _buildRow(
          label: 'GST',
          amount: response.gst,
        ),
        _buildRow(
          label: 'SEBI',
          amount: response.sebi,
        ),
        _buildRow(
          label: 'Stampduty',
          amount: response.stampduty,
        ),
      ],
    );
  }

  _buildRow(
      {String label,
      double amount,
      Widget divider = const Divider(
        height: 1.0,
      )}) {
    return Column(
      children: [
        Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                width: 200,
                child: Text(
                  '${amount.toStringAsFixed(2)} ₹',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: Constants.FIXED_FONT,
                  ),
                ),
              )
            ],
          ),
        ),
        divider,
      ],
    );
  }

  _buildProfitOrLossRow(
      {BuildContext context, CalculateResponseModel response}) {
    Color color = response.profitOrLoss > 0 ? Colors.green : Colors.red;
    return Column(
      children: [
        Container(
          height: 45,
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  response.profitOrLoss > 0 ? 'Profit' : 'Loss',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                height: 45,
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width / 3,
                color: color,
                padding: EdgeInsets.only(right: 4.0),
                child: Text(
                  '${response.profitOrLoss.toStringAsFixed(2)} ₹',
                  textAlign: TextAlign.right,
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
