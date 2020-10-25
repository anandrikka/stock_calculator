import 'package:flutter/material.dart';

class AccountTextFormField extends StatelessWidget {
  final String initialValue;
  final Function onChange;
  final String title;
  final String placeholder;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final bool readOnly;

  AccountTextFormField(
      {this.initialValue,
      @required this.onChange,
      this.title = '',
      this.placeholder = '',
      this.textInputAction = TextInputAction.next,
      this.textInputType = const TextInputType.numberWithOptions(
        signed: true,
      ),
      this.textAlign = TextAlign.right,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      initialValue: initialValue,
      onChanged: onChange,
      // onSaved: onChange,
      textInputAction: textInputAction,
      textAlign: textAlign,
      keyboardType: textInputType,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: title,
        labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        alignLabelWithHint: true,
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        contentPadding: EdgeInsets.all(12.0),
      ),
    );
  }
}
