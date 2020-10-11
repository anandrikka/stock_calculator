import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/models/calculate_request_model.dart';
import 'package:stockcalculator/models/option.dart';
import 'package:stockcalculator/providers/account_provider.dart';
import 'package:stockcalculator/providers/app_user_config_provider.dart';
import 'package:stockcalculator/providers/fee_config_provider.dart';
import 'package:stockcalculator/utils/alerts.dart';
import 'package:stockcalculator/utils/enum_lists.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/common/choose_alert_dialog.dart';
import 'package:stockcalculator/widgets/common/radio_button.dart';
import 'package:stockcalculator/widgets/home/calculate_result.dart';

class CalculatorScreen extends StatefulWidget {
  final String title;

  CalculatorScreen({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CalculatorScreen> {
  TextEditingController _buyController = TextEditingController();
  TextEditingController _sellController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  // FocusNode _buyFocus = FocusNode();
  // FocusNode _sellFocus = FocusNode();
  // FocusNode _quantityFocus = FocusNode();
  // FocusNode _amountFocus = FocusNode();

  TradingOption _tradeType = TradingOption.EQUITY_DELIVERY;
  TradeExchange _exchange = TradeExchange.BSE;
  int _account = 1;
  List<AccountEntity> _accounts;
  bool _useMultipleAccounts = false;
  bool _showResult = false;

  _setUserPrefs() {
    Map<UserPreference, dynamic> userConfig =
        Provider.of<AppUserConfigProvider>(context, listen: true).userConfig;
    _accounts = Provider.of<AccountProvider>(context, listen: true).accounts;
    _tradeType =
        userConfig[UserPreference.DEFAULT_TRADING_OPTION] as TradingOption;
    _exchange = userConfig[UserPreference.DEFAULT_EXCHANGE] as TradeExchange;
    _account = userConfig[UserPreference.DEFAULT_ACCOUNT] as int;
    _useMultipleAccounts =
        userConfig[UserPreference.USE_MULTIPLE_ACCOUNTS] as bool;
  }

  @override
  void didChangeDependencies() {
    _setUserPrefs();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(CalculatorScreen oldWidget) {
    // _setUserPrefs();
    super.didUpdateWidget(oldWidget);
  }

  double get buyPrice => _buyController.text.convertToDouble();
  double get sellPrice => _sellController.text.convertToDouble();
  double get quantity => _quantityController.text.convertToDouble();
  double get amount => _amountController.text.convertToDouble();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.help,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _buildInputField(
                  context: context,
                  label: 'Trading Type',
                  hint: 'Choose Trading Type...',
                  readOnly: true,
                  onTap: () async {
                    TradingOption selectedVal = await showDialog(
                      builder: (context) => ChooseAlertDialog<TradingOption>(
                        options: EnumsAsList.getTradingOptions(),
                        value: _tradeType,
                        title: 'Select Trade Type',
                      ),
                      context: context,
                    );
                    if (null != selectedVal) {
                      setState(() {
                        _tradeType = selectedVal;
                      });
                    }
                  },
                  controller: TextEditingController(text: _tradeType.label),
                ),
                if (_useMultipleAccounts)
                  _buildInputField(
                    context: context,
                    label: 'Account',
                    hint: 'Choose Trading Account...',
                    readOnly: true,
                    onTap: () async {
                      int selectedVal = await showDialog(
                        builder: (context) => ChooseAlertDialog<int>(
                          options: _accounts
                              .map((account) => Option<int>(
                                    label: account.accountName,
                                    value: account.id,
                                  ))
                              .toList(),
                          value: _account,
                          title: 'Select Account',
                        ),
                        context: context,
                      );
                      if (null != selectedVal) {
                        setState(() {
                          _account = selectedVal;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text:
                            Provider.of<AccountProvider>(context, listen: false)
                                .getAccountName(_account)),
                  ),
                _buildBuyOrSellPrice(context),
                _buildQuantityOrAmount(context),
                _buildExchangeRadioGroup(),
                _buildButtonBar(context),
                if (_showResult)
                  Consumer<FeeConfigProvider>(
                    builder: (_, fcp, __) {
                      if (!fcp.loaded) {
                        return SizedBox();
                      }
                      CalculateRequestModel calcModel = CalculateRequestModel(
                        exchange: _exchange,
                        tradeType: _tradeType,
                        buyPrice: buyPrice,
                        sellPrice: sellPrice,
                        quantity: quantity,
                        amount: amount,
                        fees: fcp.feeConfig,
                        account: _accounts.firstWhere(
                          (account) => account.id == _account,
                          orElse: () => AccountEntity.create(),
                        ),
                      );
                      return CalculateResults(
                        inputs: calcModel,
                        show: _showResult,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildInputField({
    BuildContext context,
    String label,
    String hint,
    bool readOnly = false,
    TextEditingController controller,
    Function onTap,
    padding = const EdgeInsets.all(0.0),
    margin = const EdgeInsets.symmetric(vertical: 8.0),
    textAlign = TextAlign.start,
    keyboardType = const TextInputType.numberWithOptions(
      signed: false,
    ),
  }) {
    return Container(
      // height: 50,
      margin: margin,
      padding: padding,
      child: TextFormField(
        keyboardType: keyboardType,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: 16.0,
        ),
        controller: controller,
        readOnly: readOnly,
        onTap: () {
          if (null != onTap) {
            onTap();
          }
        },
        onFieldSubmitted: (_) {
          // print('ok');
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                5.0,
              ),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
          ),
        ),
      ),
    );
  }

  Row _buildQuantityOrAmount(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: _buildInputField(
            context: context,
            hint: '400',
            label: 'Quantity',
            textAlign: TextAlign.right,
            controller: _quantityController,
          ),
        ),
        SizedBox(
          width: 50,
          child: Center(
            child: Text('OR'),
          ),
        ),
        Expanded(
          child: _buildInputField(
            context: context,
            hint: '10000',
            label: 'Buy Amount',
            textAlign: TextAlign.right,
            controller: _amountController,
          ),
        ),
      ],
    );
  }

  Row _buildBuyOrSellPrice(context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildInputField(
            context: context,
            hint: '1000',
            label: 'Buy Price',
            textAlign: TextAlign.right,
            controller: _buyController,
          ),
        ),
        SizedBox(
          width: 50,
        ),
        Expanded(
          child: _buildInputField(
            context: context,
            hint: '1200',
            label: 'Sell Price',
            textAlign: TextAlign.right,
            controller: _sellController,
          ),
        ),
      ],
    );
  }

  ButtonBar _buildButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text(
            'Reset',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: reset,
        ),
        Builder(
          builder: (context) => ElevatedButton(
            child: Text('Calculate'),
            onPressed: () => calculate(context),
          ),
        )
      ],
    );
  }

  Row _buildExchangeRadioGroup() {
    onExchangeChange(val) {
      setState(() {
        _exchange = val;
      });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RadioButton<TradeExchange>(
          label: TradeExchange.BSE.name,
          groupValue: _exchange,
          value: TradeExchange.BSE,
          onChanged: onExchangeChange,
        ),
        RadioButton<TradeExchange>(
          label: TradeExchange.NSE.name,
          groupValue: _exchange,
          value: TradeExchange.NSE,
          onChanged: onExchangeChange,
        ),
      ],
    );
  }

  calculate(context) {
    String message = '';
    if (buyPrice.isEmpty() &&
        sellPrice.isEmpty() &&
        quantity.isEmpty() &&
        amount.isEmpty()) {
      message = 'Form submitted with empty values.';
    } else if (buyPrice.isEmpty() && sellPrice.isEmpty()) {
      message = 'Either "Buy Price" or "Sell Price" is missing.';
    } else if (amount.isEmpty() && quantity.isEmpty()) {
      message = 'Either "Quantity" or "Amount" is missing.';
    } else if (amount.isNotEmpty() &&
        buyPrice.isEmpty() &&
        quantity.isEmpty()) {
      message = 'Amount is used to calculate fee only on "Buy Side".';
    }
    if (message.isNotEmpty) {
      showAlert(
        context: context,
        message: message,
      );
      return;
    }
    if (quantity.isNotEmpty() && amount.isNotEmpty()) {
      showAlert(
        context: context,
        message: 'Amount will be ignored for calculation.',
        alertType: AlertType.Warning,
      );
    }
    setState(() {
      _showResult = true;
    });
  }

  reset() {
    _buyController.value = TextEditingValue(text: '');
    _sellController.value = TextEditingValue(text: '');
    _quantityController.value = TextEditingValue(text: '');
    _amountController.value = TextEditingValue(text: '');
    setState(() {
      _showResult = false;
    });
  }
}
