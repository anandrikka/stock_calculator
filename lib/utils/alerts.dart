import 'package:flutter/material.dart';

enum AlertType {
  Success,
  Warning,
  Error,
}

showAlert({
  @required BuildContext context,
  @required String message,
  AlertType alertType = AlertType.Error,
}) {
  Scaffold.of(context).showSnackBar(
    getAlertSnackBar(
      context: context,
      alertType: alertType,
      message: message,
    ),
  );
}

Widget getAlertSnackBar({
  AlertType alertType = AlertType.Error,
  BuildContext context,
  String message,
}) {
  return SnackBar(
    duration: Duration(seconds: 3),
    backgroundColor: alertType == AlertType.Error
        ? Theme.of(context).errorColor
        : alertType == AlertType.Success
            ? Colors.green
            : Colors.deepOrange,
    content: Text(message),
  );
}
