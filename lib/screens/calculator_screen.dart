import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/models/calculate_request_model.dart';
import 'package:stockcalculator/models/option.dart';
import 'package:stockcalculator/providers/account_provider.dart';
import 'package:stockcalculator/providers/app_user_config_provider.dart';
import 'package:stockcalculator/providers/fee_config_provider.dart';
import 'package:stockcalculator/utils/enum_lists.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/common/choose_alert_dialog.dart';
import 'package:stockcalculator/widgets/home/calculate_result.dart';
import 'package:stockcalculator/widgets/home/estimate_quantity.dart';

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
  var _formKey = GlobalKey<FormState>();
  TextEditingController _buyPriceControl = TextEditingController();
  TextEditingController _sellPriceControl = TextEditingController();
  TextEditingController _quantityControl = TextEditingController();
  TextEditingController _lotSizeControl = TextEditingController(
    text: '1000',
  );
  TextEditingController _strikePriceControl = TextEditingController();

  FocusNode _buyPriceFocus = FocusNode();
  FocusNode _sellPriceFocus = FocusNode();
  FocusNode _quantityFocus = FocusNode();
  FocusNode _lotSizeFocus = FocusNode();
  FocusNode _strikePriceFocus = FocusNode();
  var _hasPrefsBeenSet = false;
  TradingOption _tradeType;
  TradeExchange _exchange;
  int _defaultAccount;
  List<AccountEntity> _accounts;
  Map<FeeType, Map<TradingOption, dynamic>> _feeConfig;
  bool _useMultipleAccounts = false;
  bool _showResult = false;
  double _gst = 0.0;

  _setUserPrefs() {
    AppUserConfigProvider appUserConfigProvider =
        Provider.of<AppUserConfigProvider>(context, listen: true);
    AccountProvider accountProvider =
        Provider.of<AccountProvider>(context, listen: true);
    FeeConfigProvider feeConfigProvider =
        Provider.of<FeeConfigProvider>(context, listen: true);
    Map<UserPreference, dynamic> userConfig = appUserConfigProvider.userConfig;
    _accounts = accountProvider.accounts;
    _feeConfig = feeConfigProvider.feeConfig;
    _gst = feeConfigProvider.gst;
    _tradeType =
        userConfig[UserPreference.DEFAULT_TRADING_OPTION] as TradingOption;
    _exchange = userConfig[UserPreference.DEFAULT_EXCHANGE] as TradeExchange;
    _defaultAccount = userConfig[UserPreference.DEFAULT_ACCOUNT] as int;
    _useMultipleAccounts =
        userConfig[UserPreference.USE_MULTIPLE_ACCOUNTS] as bool;
    _hasPrefsBeenSet = appUserConfigProvider.loaded && feeConfigProvider.loaded;
  }

  @override
  void didChangeDependencies() {
    _setUserPrefs();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(CalculatorScreen oldWidget) {
    _setUserPrefs();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.help,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => AboutScreen(),
          //       ),
          //     );
          //   },
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: !_hasPrefsBeenSet
                ? SizedBox()
                : Column(
                    children: <Widget>[
                      _buildTradingType(context),
                      if (_useMultipleAccounts) _buildTradingAccount(context),
                      _buildBuyPriceSellPriceAndStrikePrice(context),
                      _buildQuantityLotSizeAndExchange(context),
                      // _buildExchangeRadioGroup(),
                      _buildButtonBar(context),
                      if (_showResult)
                        Builder(
                          builder: (context) {
                            CalculateRequestModel calcModel =
                                CalculateRequestModel(
                              exchange: _exchange,
                              tradeType: _tradeType,
                              buyPrice: _buyPriceControl.text.convertToDouble(),
                              sellPrice:
                                  _sellPriceControl.text.convertToDouble(),
                              quantity: _quantityControl.text.convertToDouble(),
                              strikePrice: _tradeType.isOptions ||
                                      _tradeType.isFutures
                                  ? _strikePriceControl.text.convertToDouble()
                                  : 0.0,
                              lotSize:
                                  _tradeType.isOptions || _tradeType.isFutures
                                      ? _lotSizeControl.text.convertToDouble()
                                      : 1.0,
                              fees: _feeConfig,
                              account: _accounts.firstWhere(
                                (account) => account.id == _defaultAccount,
                                orElse: () => AccountEntity.create(),
                              ),
                              gst: _gst,
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

  _buildTradingType(BuildContext context) {
    return _buildInputField(
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
            _buyPriceControl.clear();
            _sellPriceControl.clear();
            _quantityControl.clear();
            _lotSizeControl.value = TextEditingValue(text: '1000');
            _strikePriceControl.clear();
          });
        }
      },
      controller: TextEditingController(text: _tradeType.label),
      focusNode: FocusNode(),
    );
  }

  _buildTradingAccount(BuildContext context) {
    return _buildInputField(
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
            value: _defaultAccount,
            title: 'Select Account',
          ),
          context: context,
        );
        if (null != selectedVal) {
          setState(() {
            _defaultAccount = selectedVal;
          });
        }
      },
      controller: TextEditingController(
          text: Provider.of<AccountProvider>(context, listen: false)
              .getAccountName(_defaultAccount)),
      focusNode: FocusNode(),
    );
  }

  Row _buildBuyPriceSellPriceAndStrikePrice(context) {
    var showStrikePrice =
        (_tradeType.isCommodityType || _tradeType.isCurrencyType) &&
            _tradeType.isOptions;
    return Row(
      children: <Widget>[
        if (showStrikePrice) ...[
          Expanded(
            child: _buildInputField(
              context: context,
              // hint: '50',
              label: 'Strike Price',
              textAlign: TextAlign.right,
              controller: _strikePriceControl,
              focusNode: _strikePriceFocus,
              validator: (String value) {
                if (showStrikePrice && value.isEmpty) return '';
                return null;
              },
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
        Expanded(
          child: _buildInputField(
            context: context,
            // hint: '1000',
            label: 'Buy Price',
            textAlign: TextAlign.right,
            controller: _buyPriceControl,
            focusNode: _buyPriceFocus,
            validator: (String value) {
              if (value.isEmpty && _sellPriceControl.text.isEmpty) return '';
              return null;
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: _buildInputField(
            context: context,
            // hint: '1100',
            label: 'Sell Price',
            textAlign: TextAlign.right,
            controller: _sellPriceControl,
            focusNode: _sellPriceFocus,
            validator: (String value) {
              if (value.isEmpty && _buyPriceControl.text.isEmpty) return '';
              return null;
            },
          ),
        ),
      ],
    );
  }

  Row _buildQuantityLotSizeAndExchange(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: _buildInputField(
            context: context,
            // hint: '400',
            label: _tradeType.isFutures || _tradeType.isOptions
                ? 'Total Lots'
                : 'Quantity',
            textAlign: TextAlign.right,
            controller: _quantityControl,
            focusNode: _quantityFocus,
            validator: (String value) {
              if (value.isEmpty) return '';
              return null;
            },
            suffix: !_tradeType.isOptions && !_tradeType.isFutures
                ? InkWell(
                    autofocus: false,
                    onTap: () async {
                      int quantity = await showDialog(
                        context: context,
                        builder: (_) => EstimateQuantity(),
                      );
                      if (null != quantity) {
                        _quantityControl.text = quantity.toString();
                      }
                    },
                    child: Icon(
                      Icons.calculate,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : null,

            onFieldSubmitted: (_) {
              calculate();
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        if (_tradeType.isOptions || _tradeType.isFutures) ...[
          Expanded(
            child: _buildInputField(
              context: context,
              // hint: '1000',
              label: 'Lot Size',
              textAlign: TextAlign.right,
              controller: _lotSizeControl,
              focusNode: _lotSizeFocus,
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
              validator: (String value) {
                if ((_tradeType.isOptions || _tradeType.isFutures) &&
                    value.isEmpty) return '';
                return null;
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        Expanded(
          child: _buildInputField(
            context: context,
            label: 'Exchange',
            hint: 'Choose Exchange...',
            readOnly: true,
            onTap: () async {
              TradeExchange selectedVal = await showDialog(
                builder: (context) => ChooseAlertDialog<TradeExchange>(
                  options: EnumsAsList.getTradeExchanges(),
                  value: _exchange,
                  title: 'Select Exchange',
                  heightFactor: 0.15,
                ),
                context: context,
              );
              if (null != selectedVal) {
                setState(() {
                  _exchange = selectedVal;
                });
              }
            },
            controller: TextEditingController(text: _exchange.name),
            focusNode: FocusNode(),
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
              color: Theme.of(context).accentColor,
            ),
          ),
          onPressed: reset,
        ),
        Builder(
          builder: (context) => ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (_) => Theme.of(context).primaryColor,
              ),
            ),
            child: Text('Calculate'),
            onPressed: () => calculate(),
          ),
        )
      ],
    );
  }

  calculate() {
    var isFormValid = _formKey.currentState.validate();
    if (isFormValid) {
      setState(() {
        _showResult = true;
      });
    }
  }

  reset() {
    _buyPriceControl.clear();
    _sellPriceControl.clear();
    _quantityControl.clear();
    _lotSizeControl.value = TextEditingValue(text: '1000');
    _strikePriceControl.clear();
    setState(() {
      _showResult = false;
    });
  }

  _buildInputField({
    BuildContext context,
    String label,
    String hint,
    bool readOnly = false,
    @required TextEditingController controller,
    Function onTap,
    padding = const EdgeInsets.all(0.0),
    margin = const EdgeInsets.symmetric(vertical: 8.0),
    textAlign = TextAlign.start,
    keyboardType = const TextInputType.numberWithOptions(
      signed: false,
    ),
    TextInputAction textInputAction = TextInputAction.next,
    Function validator,
    Widget suffix,
    @required FocusNode focusNode,
    Function onFieldSubmitted,
  }) {
    InputDecoration decoration = InputDecoration(
      errorStyle: TextStyle(
        height: 0,
      ),
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
      suffixIcon: null != suffix
          ? suffix
          : SizedBox(
              width: 0,
              height: 0,
            ),
      suffixIconConstraints: null != suffix
          ? BoxConstraints(
              maxWidth: 36,
              maxHeight: 36,
              minWidth: 32,
              minHeight: 32,
            )
          : BoxConstraints(
              maxHeight: 0,
              maxWidth: 0,
            ),
    );
    return Container(
      // height: 50,
      margin: margin,
      padding: padding,
      child: TextFormField(
        autofocus: false,
        keyboardType: keyboardType,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: 16.0,
        ),
        textInputAction: textInputAction,
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        onTap: () {
          if (null != onTap) {
            onTap();
          }
        },
        onFieldSubmitted: onFieldSubmitted,
        decoration: decoration,
        validator: (value) {
          if (null == validator) {
            return null;
          }
          return validator(value);
        },
      ),
    );
  }
}
