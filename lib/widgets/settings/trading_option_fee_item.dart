import 'package:flutter/material.dart';
import 'package:stock_calculator/utils/constants.dart';

class TradingOptionFeeItem extends StatelessWidget {
  final String label;

  TradingOptionFeeItem({
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          decoration: BoxDecoration(
              // color: Colors.white,
              // border: Border(
              //   bottom: BorderSide(color: Colors.grey, width: 0.4),
              // ),
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(label),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontFamily: Constants.FIXED_FONT,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '0.000',
                    suffix: SizedBox(
                      width: 10,
                      child: Center(
                        child: Text('%'),
                      ),
                    ),
                    border: OutlineInputBorder(
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 4.0,
                    ),
                    // fillColor: Color.fromRGBO(240, 240, 240, 1),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontFamily: Constants.FIXED_FONT,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '0.000',
                    suffix: SizedBox(
                      width: 10,
                      child: Center(
                        child: Text('%'),
                      ),
                    ),
                    border: OutlineInputBorder(
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 4.0,
                    ),
                    // fillColor: Color.fromRGBO(240, 240, 240, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
