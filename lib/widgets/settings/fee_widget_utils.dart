import 'package:flutter/material.dart';
import 'package:stock_calculator/models/option.dart';
import 'package:stock_calculator/utils/constants.dart';
import 'package:stock_calculator/utils/enums.dart';

final double widthFactor = 1 / 3;

getTradingOptions() {
  List<Option<TradingOption>> tradingOptions = [];
  var groups = TradingOption.values.map((v) => v.group).toSet();
  groups.forEach((group) {
    tradingOptions.add(Option(
      label: group.capitalize(),
      isHeader: true,
    ));
    TradingOption.values.where((to) => group == to.group).forEach((to) {
      tradingOptions.add(Option<TradingOption>(
          label: to.typeLabel, value: to, isHeader: false));
    });
  });
  return tradingOptions;
}

Widget buildHeader({BuildContext context, String title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 20,
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: Constants.HEADING_FONT,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    ],
  );
}

Widget buildFeeInputValue({
  BuildContext context,
  TextEditingController controller,
  double widthFactor = 1 / 3,
  suffix = '%',
}) {
  final double width = MediaQuery.of(context).size.width * widthFactor;
  final EdgeInsets margin =
      EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0);
  return Container(
    width: width,
    margin: margin,
    child: Text(
      null != controller.value ? '${controller.value.text}$suffix' : '',
      style: TextStyle(
        fontSize: 18.0,
        fontFamily: Constants.FIXED_FONT,
      ),
      textAlign: TextAlign.right,
    ),
  );
}

Widget buildFeeInput({
  BuildContext context,
  TextEditingController controller,
  String suffix = '%',
  double widthFactor = 1 / 3,
}) {
  final double width = MediaQuery.of(context).size.width * widthFactor;
  final EdgeInsets margin =
      EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0);
  return Container(
    width: width,
    margin: margin,
    // height: 35,
    child: TextField(
      textInputAction: TextInputAction.done,
      textAlignVertical: TextAlignVertical.top,
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontFamily: Constants.FIXED_FONT,
        fontSize: 18,
      ),
      textAlign: TextAlign.right,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: '0.00',
        suffix: Padding(
          padding: const EdgeInsets.only(
            right: 2.0,
          ),
          child: SizedBox(
            width: 10,
            child: Center(
              child: Text(suffix),
            ),
          ),
        ),
        border: OutlineInputBorder(
          // borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding:
            EdgeInsets.only(top: 1.0, bottom: 4.0, left: 4.0, right: 4.0),
      ),
    ),
  );
}

Widget buildTextInput({
  TextEditingController controller,
  bool isLast = false,
  BuildContext context,
  bool editMode,
  String suffix = '%',
}) {
  return TextFormField(
    style: TextStyle(
      fontFamily: Constants.FIXED_FONT,
      fontSize: 16.0,
    ),
    textInputAction: isLast ? TextInputAction.next : TextInputAction.done,
    keyboardType: TextInputType.numberWithOptions(
      signed: false,
    ),
    textAlign: TextAlign.right,
    readOnly: !editMode,
    controller: controller,
    decoration: InputDecoration(
      isDense: true,
      suffixText: suffix,
      suffixStyle: TextStyle(
        color: Theme.of(context).accentColor,
      ),
      hintText: '0.0',
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      contentPadding: EdgeInsets.all(10.0),
    ),
  );
}
