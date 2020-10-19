import 'package:flutter/material.dart';
import 'package:stockcalculator/utils/enum_lists.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/settings/fee_widget_utils.dart'
    as feeWidgetUtils;

class AccountFee extends StatelessWidget {
  final Map<TradingOption, Map<String, dynamic>> controllers;
  final TextEditingController accountController;
  final bool edit;
  final Function setFlatFee;
  final double _rowHeight = 55.0;
  final double _inputWidth = 90.0;

  AccountFee({
    this.controllers,
    this.accountController,
    this.edit,
    this.setFlatFee,
  });

  @override
  Widget build(BuildContext context) {
    var tradingOptions = EnumsAsList.getTradingOptions();
    return Form(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: TextFormField(
              controller: accountController,
              readOnly: !edit,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Enter Account Name',
                labelText: 'Account Name',
                border: edit
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            5.0,
                          ),
                        ),
                      )
                    : InputBorder.none,
                contentPadding: EdgeInsets.all(edit ? 8.0 : 0.0),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: tradingOptions
                  .map<List<Widget>>(
                    (option) {
                      Map<String, dynamic> fees = controllers[option.value];
                      bool isFlatFee = fees['flat'] as bool;
                      Map<String, TextEditingController>
                          clearingFeeControllers = fees['clearingFee']
                              as Map<String, TextEditingController>;
                      return [
                        feeWidgetUtils.buildHeader(
                            context: context, title: option.label),
                        _buildFlatFeeRow(
                          context: context,
                          fees: fees,
                          tradingOption: option.value,
                        ),
                        if (!isFlatFee) ...[
                          _buildFeeRow(
                            context: context,
                            label: 'Minimum Fee (₹)',
                            controller: fees['min'] as TextEditingController,
                          ),
                          _buildFeeRow(
                            context: context,
                            label: 'Fee (%)',
                            controller:
                                fees['percent'] as TextEditingController,
                          ),
                          _buildFeeRow(
                            context: context,
                            label: 'Maximum Fee (₹)',
                            controller: fees['max'] as TextEditingController,
                          ),
                        ],
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          height: 35.0,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Clearing Fees',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        _buildFeeRow(
                          context: context,
                          label: 'NSE (%)',
                          controller:
                              clearingFeeControllers[TradeExchange.NSE.name],
                          padding: EdgeInsets.only(left: 24.0, right: 16.0),
                        ),
                        _buildFeeRow(
                          context: context,
                          label: 'BSE (%)',
                          controller:
                              clearingFeeControllers[TradeExchange.BSE.name],
                          padding: EdgeInsets.only(left: 24.0, right: 16.0),
                        ),
                      ];
                    },
                  )
                  .expand((widgets) => widgets)
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  _buildFeeRow({
    BuildContext context,
    TextEditingController controller,
    String label,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) {
    return Container(
      height: _rowHeight,
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(
            width: _inputWidth,
            child: feeWidgetUtils.buildTextInput(
              context: context,
              controller: controller,
              isLast: false,
              editMode: edit,
            ),
          ),
        ],
      ),
    );
  }

  _buildFlatFeeRow({
    BuildContext context,
    Map<String, dynamic> fees,
    TradingOption tradingOption,
  }) {
    bool flat = fees['flat'] as bool;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: _rowHeight,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3.0,
            child: Text(
              'Flat Fee (₹)',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 3.0,
            child: SizedBox(
              child: Switch(
                value: flat,
                onChanged: (_) {
                  setFlatFee(tradingOption);
                },
              ),
            ),
          ),
          if (flat)
            Expanded(
              child: SizedBox(
                width: _inputWidth,
                child: feeWidgetUtils.buildTextInput(
                  context: context,
                  controller: fees['flatRate'] as TextEditingController,
                  editMode: edit,
                  isLast: false,
                ),
              ),
            )
        ],
      ),
    );
  }
}
