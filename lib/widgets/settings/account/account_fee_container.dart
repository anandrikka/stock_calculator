import 'package:flutter/material.dart';

class AccountFeeContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final EdgeInsets padding;

  AccountFeeContainer({
    this.child,
    this.height = 55.0,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 8.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      child: null != child ? child : const SizedBox(),
    );
  }
}
