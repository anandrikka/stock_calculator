import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/models/account_fee_model.dart';
import 'package:stockcalculator/providers/account_provider.dart';
import 'package:stockcalculator/repo/account_repository.dart';
import 'package:stockcalculator/screens/account_management_screen.dart';
import 'package:stockcalculator/utils/alerts.dart';
import 'package:stockcalculator/utils/enum_lists.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/common/loader.dart';
import 'package:stockcalculator/widgets/settings/account/account_fee_section.dart';
import 'package:stockcalculator/widgets/settings/account/account_text_form_field.dart';

class AddOrEditAccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class ExpandableItem {
  bool expanded;
  final TradingOption tradingOption;
  final String header;
  ExpandableItem(this.expanded, this.tradingOption, this.header);
}

class _AccountScreenState extends State<AddOrEditAccountScreen> {
  GlobalKey _key = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  AccountRepository _accRepo = AccountRepository();
  String _mode;
  AccountEntity _acc;
  bool _edit = false;

  bool get isNew => _mode == AccountManagementScreen.MODE_ADD;

  List<ExpandableItem> _expandableTradingOptions =
      EnumsAsList.getTradingOptions()
          .map((option) => ExpandableItem(
                false,
                option.value,
                option.label,
              ))
          .toList();

  @override
  void didChangeDependencies() {
    _useRouteParams();
    super.didChangeDependencies();
  }

  void _useRouteParams() async {
    Map<String, dynamic> routeParams =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _mode = routeParams['mode'] as String;
    AccountEntity account;
    if (_mode == AccountManagementScreen.MODE_ADD) {
      account = AccountEntity.create();
    } else {
      var accountId = routeParams['accountId'] as int;
      account = await _accRepo.getById(accountId);
    }
    setState(() {
      _acc = account;
    });
  }

  _onAccountNameChange(String value) {
    _acc.accountName = value;
  }

  _onDpFeeChange(String value) {
    _acc.dpFee = value.convertToDouble();
  }

  _updateFeeSection(TradingOption option, AccountFeeModel model) {
    setState(() {
      _acc.fees[option] = model;
    });
  }

  _getTitleText() {
    return AccountManagementScreen.MODE_ADD == _mode
        ? Text('Add Account')
        : Text('Edit Account');
  }

  refresh() {
    setState(() {});
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
                  print(_acc.toJson());
                  try {
                    if (null != _acc) {
                      _acc.accountName = _acc.accountName.capitalize();
                      await Provider.of<AccountProvider>(context, listen: false)
                          .createOrUpdateAccount(_acc);
                      Navigator.pop(context);
                    }
                  } on DatabaseException catch (e) {
                    if (e.isUniqueConstraintError(
                        AccountEntity.COLUMN_ACCOUNT_NAME)) {
                      showAlert(
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
      body: null == _acc
          ? Loader()
          : Form(
              onChanged: () {},
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: AccountTextFormField(
                      readOnly: !_edit && !isNew,
                      title: 'Account Name',
                      placeholder: 'Enter Account Name',
                      initialValue: _acc.accountName,
                      onChange: _onAccountNameChange,
                      textAlign: TextAlign.left,
                      textInputType: TextInputType.text,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'DP charges (₹)',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120.0,
                          child: AccountTextFormField(
                            readOnly: !_edit && !isNew,
                            title: '',
                            placeholder: '',
                            initialValue: _acc.dpFee.toStringSafe(),
                            onChange: _onDpFeeChange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 0.0,
                    ),
                    elevation: 0,
                    animationDuration: Duration(
                      milliseconds: 500,
                    ),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _expandableTradingOptions[index].expanded =
                            !_expandableTradingOptions[index].expanded;
                      });
                    },
                    children: _expandableTradingOptions
                        .map(
                          (option) => ExpansionPanel(
                            headerBuilder: (_, __) {
                              return ListTile(
                                title: Text(option.header),
                              );
                            },
                            body: AccountFeeSection(
                              refresh: refresh,
                              readOnly: !_edit && !isNew,
                              tradingOption: option.tradingOption,
                              accountFeeModel: _acc.fees[option.tradingOption],
                              updateFeeSection: _updateFeeSection,
                            ),
                            isExpanded: option.expanded,
                            canTapOnHeader: true,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
