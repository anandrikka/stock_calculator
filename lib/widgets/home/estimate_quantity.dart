import 'package:flutter/material.dart';
import 'package:stockcalculator/utils/enums.dart';

class EstimateQuantity extends StatefulWidget {
  @override
  _EstimateQuantityState createState() => _EstimateQuantityState();
}

class _EstimateQuantityState extends State<EstimateQuantity> {
  var _unitPriceController = TextEditingController();
  var _amountController = TextEditingController();
  var _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Estimate Quantity',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.all(16.0),
      titlePadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        width: MediaQuery.of(context).size.width * 0.80,
        child: Form(
          key: _form,
          onChanged: () {
            print('form');
          },
          child: Row(
            children: [
              Expanded(
                child: _buildInput(
                  controller: _unitPriceController,
                  label: 'Unit Price',
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: _buildInput(
                    controller: _amountController,
                    label: 'Amount',
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (_form.currentState.validate()) {
                        _estimateQuantity();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        ElevatedButton(
          onPressed: _estimateQuantity,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (_) => Theme.of(context).primaryColor,
            ),
          ),
          child: Text('Estimate'),
        )
      ],
    );
  }

  _estimateQuantity() {
    double unitPrice = _unitPriceController.value.text.convertToDouble();
    double amount = _amountController.value.text.convertToDouble();
    int quantity = (amount / unitPrice).floor();
    Navigator.of(context).pop(quantity);
  }

  _buildInput({
    TextEditingController controller,
    String label,
    TextInputAction textInputAction,
    Function onFieldSubmitted,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: TextStyle(
          height: 0,
        ),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              5.0,
            ),
          ),
        ),
      ),
      textInputAction: textInputAction,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.numberWithOptions(
        signed: false,
      ),
      autofocus: true,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      validator: (String value) {
        return value.isEmpty ? '' : null;
      },
    );
  }
}
