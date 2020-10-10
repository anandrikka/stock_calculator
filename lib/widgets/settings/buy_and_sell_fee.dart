import 'package:flutter/material.dart';
import 'package:stock_calculator/models/option.dart';
import 'package:stock_calculator/utils/enums.dart';
import 'package:stock_calculator/widgets/settings/fee_widget_utils.dart'
    as feeWidgetUtils;

class BuyAndSellFee extends StatelessWidget {
  final bool editMode;
  final Map<TradingOption, dynamic> fees;
  final FeeType feeType;

  BuyAndSellFee({this.editMode, this.fees, this.feeType});

  @override
  Widget build(BuildContext context) {
    List<Option> tradingOptions = feeWidgetUtils.getTradingOptions();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainHeader(context),
        Expanded(
          child: Form(
            child: ListView.separated(
              itemBuilder: (_, index) {
                Option option = tradingOptions[index];
                if (option.isHeader) {
                  return feeWidgetUtils.buildHeader(
                    context: context,
                    title: option.label,
                  );
                }
                TextEditingController buyController = TextEditingController();
                TextEditingController sellController = TextEditingController();
                if (null != fees[option.value]) {
                  buyController =
                      fees[option.value]['buy'] as TextEditingController;
                  sellController =
                      fees[option.value]['sell'] as TextEditingController;
                }
                return Container(
                  height: 55,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          child: feeWidgetUtils.buildTextInput(
                            context: context,
                            controller: buyController,
                            editMode: editMode,
                          ),
                          width: 90,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          child: feeWidgetUtils.buildTextInput(
                            controller: sellController,
                            context: context,
                            editMode: editMode,
                          ),
                          width: 90,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(
                height: 0,
                thickness: 0,
                color: Colors.white,
              ),
              itemCount: tradingOptions.length,
            ),
          ),
        )
      ],
    );
  }

  // Widget _buildInputField1({
  //   BuildContext context,
  //   TextEditingController controller,
  // }) {
  //   return TextFormField(
  //     style: TextStyle(
  //       fontFamily: Constants.FIXED_FONT,
  //     ),
  //     keyboardType: TextInputType.numberWithOptions(
  //       signed: false,
  //     ),
  //     textAlign: TextAlign.right,
  //     readOnly: !editMode,
  //     controller: controller,
  //     decoration: InputDecoration(
  //       suffixText: '%',
  //       suffixStyle: TextStyle(
  //         color: Theme.of(context).accentColor,
  //       ),
  //       hintText: '0.0',
  //       border: OutlineInputBorder(
  //         borderSide: BorderSide(width: 1.0),
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(5.0),
  //         ),
  //       ),
  //       contentPadding: EdgeInsets.symmetric(
  //         horizontal: 8.0,
  //         vertical: 8.0,
  //       ),
  //     ),
  //   );
  // }
}

Widget _buildMainHeader(context) {
  var margin = const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0);
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
        ),
        SizedBox(
          width: 100,
          child: const Text(
            'BUY',
            style: const TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 100,
          child: const Text(
            'SELL',
            style: const TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
