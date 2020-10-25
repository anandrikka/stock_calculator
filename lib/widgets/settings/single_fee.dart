import 'package:flutter/material.dart';
import 'package:stockcalculator/models/option.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/settings/fee_widget_utils.dart'
    as feeWidgetUtils;

class SingleFee extends StatelessWidget {
  final bool editMode;
  final Map<TradingOption, dynamic> fees;
  final FeeType feeType;
  SingleFee({this.editMode, this.fees, this.feeType});

  @override
  Widget build(BuildContext context) {
    List<Option> tradingOptions = feeWidgetUtils.getTradingOptions();
    var totalOptions = tradingOptions.length;
    double inputWidth = feeType == FeeType.GST ? 90.0 : 110.0;
    return Form(
      child: ListView.separated(
        itemBuilder: (_, index) {
          Option option = tradingOptions[index];
          if (option.isHeader) {
            return feeWidgetUtils.buildHeader(
              context: context,
              title: option.label,
            );
          }
          TextEditingController controller = TextEditingController();
          if (null != fees[option.value]) {
            controller = fees[option.value] as TextEditingController;
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
                    '${option.label} (%)',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: inputWidth,
                  child: feeWidgetUtils.buildTextInput(
                    context: context,
                    controller: controller,
                    isLast: index < totalOptions - 1,
                    editMode: editMode,
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
    );
  }
}
