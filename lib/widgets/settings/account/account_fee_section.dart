import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockcalculator/models/account_fee_model.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/settings/account/account_fee_container.dart';
import 'package:stockcalculator/widgets/settings/account/account_text_form_field.dart';

class AccountFeeSection extends StatefulWidget {
  final TradingOption tradingOption;
  final AccountFeeModel accountFeeModel;
  final Function updateFeeSection;
  final bool readOnly;
  final Function refresh;

  AccountFeeSection({
    this.tradingOption,
    this.accountFeeModel,
    this.updateFeeSection,
    this.readOnly,
    this.refresh,
  });

  @override
  _AccountFeeSectionState createState() => _AccountFeeSectionState();
}

class _AccountFeeSectionState extends State<AccountFeeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 64.0,
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            children: [
              Expanded(
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
                    value: widget.accountFeeModel.flatFee.flag,
                    onChanged: (_) {
                      if (!widget.readOnly) {
                        widget.accountFeeModel.flatFee.flag =
                            !widget.accountFeeModel.flatFee.flag;
                        widget.updateFeeSection(
                            widget.tradingOption, widget.accountFeeModel);
                      }
                    },
                  ),
                ),
              ),
              if (!widget.accountFeeModel.flatFee.flag)
                Expanded(
                  child: SizedBox(),
                )
              else
                Expanded(
                  child: AccountTextFormField(
                    readOnly: widget.readOnly,
                    initialValue:
                        widget.accountFeeModel.flatFee.rate.toStringSafe(),
                    placeholder: '0.0 %',
                    onChange: (String value) {
                      widget.accountFeeModel.flatFee.rate =
                          value.convertToDouble();
                    },
                  ),
                ),
            ],
          ),
        ),
        // if (!widget.accountFeeModel.isFlat &&
        //     (widget.tradingOption.isFutures || widget.tradingOption.isOptions))
        //   Container(
        //     height: 64,
        //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: Text(
        //             'Fee Per Lot (₹)',
        //             style: TextStyle(
        //               fontSize: 16.0,
        //             ),
        //           ),
        //         ),
        //         Container(
        //           alignment: Alignment.center,
        //           width: MediaQuery.of(context).size.width / 3.0,
        //           child: SizedBox(
        //             child: Switch(
        //               value: widget.accountFeeModel.isPerLot,
        //               onChanged: (_) {
        //                 if (!widget.readOnly) {
        //                   widget.accountFeeModel.lotFee.flag =
        //                       !widget.accountFeeModel.lotFee.flag;
        //                   widget.refresh();
        //                 }
        //               },
        //             ),
        //           ),
        //         ),
        //         if (!widget.accountFeeModel.lotFee.flag)
        //           Expanded(
        //             child: SizedBox(),
        //           )
        //         else
        //           Expanded(
        //             child: AccountTextFormField(
        //               placeholder: '0.0 %',
        //               initialValue:
        //                   widget.accountFeeModel.lotFee.rate.toStringSafe(),
        //               readOnly: widget.readOnly,
        //               onChange: (String value) {
        //                 widget.accountFeeModel.lotFee.rate =
        //                     value.convertToDouble();
        //               },
        //             ),
        //           ),
        //       ],
        //     ),
        //   ),
        if (!widget.accountFeeModel.flatFee.flag)
          Container(
            height: 64.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: AccountTextFormField(
                    readOnly: widget.readOnly,
                    title: 'Min Fee (₹)',
                    placeholder: '0.0 ₹',
                    initialValue: widget.accountFeeModel.min.toStringSafe(),
                    onChange: (String value) {
                      widget.accountFeeModel.min = value.convertToDouble();
                    },
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: AccountTextFormField(
                    readOnly: widget.readOnly,
                    title: 'Percent (%)',
                    placeholder: '0.0 %',
                    initialValue: widget.accountFeeModel.percent.toStringSafe(),
                    onChange: (String value) {
                      widget.accountFeeModel.percent = value.convertToDouble();
                    },
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: AccountTextFormField(
                    readOnly: widget.readOnly,
                    title: 'Max Fee (₹)',
                    placeholder: '0.0 ₹',
                    initialValue: widget.accountFeeModel.max.toStringSafe(),
                    onChange: (String value) {
                      widget.accountFeeModel.max = value.convertToDouble();
                    },
                  ),
                )
              ],
            ),
          ),
        AccountFeeContainer(
          height: 64.0,
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Clearing Fees (%)',
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
                    value: widget.accountFeeModel.clearingFee.flag,
                    onChanged: (_) {
                      if (!widget.readOnly) {
                        widget.accountFeeModel.clearingFee.flag =
                            !widget.accountFeeModel.clearingFee.flag;
                        widget.refresh();
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
        if (widget.accountFeeModel.clearingFee.flag)
          Container(
            height: 64.0,
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AccountTextFormField(
                    initialValue:
                        widget.accountFeeModel.clearingFee.bse.toStringSafe(),
                    readOnly: widget.readOnly,
                    onChange: (String value) {
                      widget.accountFeeModel.clearingFee.bse =
                          value.convertToDouble();
                    },
                    title: 'BSE (%)',
                    placeholder: '0.0 %',
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: AccountTextFormField(
                    initialValue:
                        widget.accountFeeModel.clearingFee.nse.toStringSafe(),
                    readOnly: widget.readOnly,
                    onChange: (String value) {
                      widget.accountFeeModel.clearingFee.nse =
                          value.convertToDouble();
                    },
                    title: 'NSE (%)',
                    placeholder: '0.0 %',
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: SizedBox(),
                )
              ],
            ),
          ),
      ],
    );
  }
}
