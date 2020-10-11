import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/models/fee_model.dart';
import 'package:stockcalculator/providers/fee_config_provider.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/settings/single_fee.dart';

class ExchangeFees extends StatefulWidget {
  final FeeType feeType;

  ExchangeFees({this.feeType});

  @override
  _ExchangeFeesState createState() => _ExchangeFeesState();
}

class _ExchangeFeesState extends State<ExchangeFees> {
  bool _edit = false;

  toggleEdit(flag) {
    setState(() {
      _edit = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeConfigProvider>(
      builder: (_, fcp, __) {
        Map<TradingOption, dynamic> fees =
            _buildTextEditingControllers(fcp.feeConfig[widget.feeType]);
        return Container(
          child: Column(
            children: [
              Expanded(
                child: SingleFee(
                  feeType: widget.feeType,
                  editMode: _edit,
                  fees: fees,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_edit) ...[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          toggleEdit(false);
                        },
                      ),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Save'),
                        onPressed: () async {
                          await Provider.of<FeeConfigProvider>(
                            context,
                            listen: false,
                          ).updateFeeConfigItems(
                            widget.feeType,
                            fees.map(
                              (
                                key,
                                value,
                              ) {
                                var controller = value as TextEditingController;
                                FeeModel model = FeeModel(
                                  percent: controller.text.convertToDouble(),
                                );
                                return MapEntry(key, model);
                              },
                            ),
                          );
                          toggleEdit(false);
                        },
                      ),
                    ] else
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Edit'),
                        onPressed: () {
                          toggleEdit(true);
                        },
                      )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _buildTextEditingControllers(Map<TradingOption, dynamic> data) {
    Map<TradingOption, dynamic> fees = {};
    if (null != data) {
      data.forEach((key, value) {
        FeeModel model = value as FeeModel;
        fees[key] = TextEditingController(text: model.percent.toString());
      });
    }
    return fees;
  }
}
