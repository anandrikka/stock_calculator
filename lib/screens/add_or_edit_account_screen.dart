import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_calculator/models/account_entity.dart';
import 'package:stock_calculator/models/fee_model.dart';
import 'package:stock_calculator/providers/account_provider.dart';
import 'package:stock_calculator/screens/account_management_screen.dart';
import 'package:stock_calculator/utils/alerts.dart' as alertUtils;
import 'package:stock_calculator/utils/enums.dart';
import 'package:stock_calculator/widgets/settings/account_fee.dart';

class AddOrEditAccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AddOrEditAccountScreen> {
  GlobalKey _key = GlobalKey();
  String _mode;
  AccountEntity _acc;
  Map<TradingOption, Map<String, dynamic>> _controllers;
  TextEditingController _accountNameController;
  bool _edit = false;

  bool get isNew => _mode == AccountManagementScreen.MODE_ADD;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> routeParams =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _mode = routeParams['mode'] as String;
    _acc = routeParams['data'] as AccountEntity;
    _accountNameController = TextEditingController(text: _acc.accountName);
    _controllers = _acc.fees.map(
      (key, value) => MapEntry(
        key,
        {
          'percent': TextEditingController(
            text: value.percent.toString(),
          ),
          'min': TextEditingController(
            text: value.min.toString(),
          ),
          'max': TextEditingController(
            text: value.max.toString(),
          ),
          'flatRate': TextEditingController(
            text: value.flatRate.toString(),
          ),
          'flat': value.flat,
        },
      ),
    );
    super.didChangeDependencies();
  }

  _getTitleText() {
    String title;
    if (_mode == AccountManagementScreen.MODE_ADD) {
      title = 'Add Account';
    } else if (_edit) {
      title = 'Edit ${_acc.accountName}';
    } else {
      title = _acc.accountName;
    }
    return Text(title);
  }

  setFlatFee(TradingOption option) {
    setState(() {
      _controllers[option]['flat'] = !_controllers[option]['flat'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        title: _getTitleText(),
        actions: [
          if (!_edit && !isNew)
            IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () {
                setState(() {
                  _edit = true;
                });
              },
            )
          else if (_edit || isNew)
            Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  try {
                    AccountEntity ae = _prepareAccount(context);
                    if (null != ae) {
                      await Provider.of<AccountProvider>(context, listen: false)
                          .createOrUpdateAccount(_prepareAccount(context));
                      Navigator.pop(context);
                    }
                  } on DatabaseException catch (e) {
                    if (e.isUniqueConstraintError(
                        AccountEntity.COLUMN_ACCOUNT_NAME)) {
                      alertUtils.showAlert(
                        context: ctx,
                        message: 'Account already exists with this name',
                      );
                    }
                  }
                },
              ),
            )
        ],
      ),
      body: AccountFee(
        controllers: _controllers,
        accountController: _accountNameController,
        edit: _edit || _mode == AccountManagementScreen.MODE_ADD,
        setFlatFee: setFlatFee,
      ),
    );
  }

  _prepareAccount(BuildContext context) {
    var accountName = _accountNameController.text;
    if (accountName.isEmpty) {
      alertUtils.showAlert(
        context: context,
        message: 'Account name is required!',
      );
      return;
    }
    if (accountName.length < 2) {
      alertUtils.showAlert(
        context: context,
        message: 'Account name should contain 2 letters!',
      );
      return;
    }
    if (accountName.split(' ').length > 1) {
      alertUtils.showAlert(
        context: context,
        message: 'Account name should be of single word',
      );
      return;
    }
    accountName = accountName.capitalize();
    var fees = _controllers.map(
      (key, value) {
        final flat = value['flat'] as bool;
        var flatRate = 0.0;
        var percent = 0.0;
        var min = 0.0;
        var max = 0.0;
        if (flat) {
          flatRate = (value['flatRate'] as TextEditingController)
              .text
              .convertToDouble();
        } else {
          percent = (value['percent'] as TextEditingController)
              .text
              .convertToDouble();
          min = (value['min'] as TextEditingController).text.convertToDouble();
          max = (value['max'] as TextEditingController).text.convertToDouble();
        }
        FeeModel fee = FeeModel(
          flat: flat,
          flatRate: flatRate,
          min: min,
          max: max,
          percent: percent,
        );
        return MapEntry(key, fee);
      },
    );
    AccountEntity ae = AccountEntity();
    if (_mode == AccountManagementScreen.MODE_EDIT) {
      ae.id = _acc.id;
    }
    ae.accountName = accountName;
    ae.fees = fees;
    ae.isActive = 1;
    ae.dpFee = 0.0;
    return ae;
  }
}
