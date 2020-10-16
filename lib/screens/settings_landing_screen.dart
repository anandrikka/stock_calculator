import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/models/option.dart';
import 'package:stockcalculator/providers/account_provider.dart';
import 'package:stockcalculator/providers/app_user_config_provider.dart';
import 'package:stockcalculator/utils/enum_lists.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/common/choose_alert_dialog.dart';
import 'package:stockcalculator/widgets/common/flutter_icons.dart';
import 'package:stockcalculator/widgets/routes/routes.dart';
import 'package:stockcalculator/widgets/settings/settings_page_list_item.dart';

class SettingsLandingScreen extends StatelessWidget {
  final String title;
  final Function onPush;

  SettingsLandingScreen({Key key, this.title, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '2.0.0',
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ..._buildUserPreferences(context),
          ..._buildAccountsManagement(context),
          ..._buildManageTaxesCharges(context),
          ..._buildSettings(context),
        ],
      ),
    );
  }

  List<Widget> _buildUserPreferences(context) {
    var userConfigProvider =
        Provider.of<AppUserConfigProvider>(context, listen: true);
    var accountProvider = Provider.of<AccountProvider>(context, listen: true);
    TradingOption defaultTradingOption = userConfigProvider
        .getConfigValue(UserPreference.DEFAULT_TRADING_OPTION) as TradingOption;
    TradeExchange defaultTradeExchange = userConfigProvider
        .getConfigValue(UserPreference.DEFAULT_EXCHANGE) as TradeExchange;
    bool useMultipleAccounts = userConfigProvider
        .getConfigValue(UserPreference.USE_MULTIPLE_ACCOUNTS) as bool;
    int defaultAccount = userConfigProvider
        .getConfigValue(UserPreference.DEFAULT_ACCOUNT) as int;
    return [
      SettingsPageListItem(header: true, title: 'User Preferences'),
      SettingsPageListItem(
        title: 'Default Trading Type',
        subtitle: defaultTradingOption.label,
        icon: Icons.show_chart,
        onClick: () async {
          TradingOption selectedVal = await showDialog(
            builder: (context) => ChooseAlertDialog<TradingOption>(
              options: EnumsAsList.getTradingOptions(),
              value: defaultTradingOption,
              title: 'Select Trade Type',
            ),
            context: context,
          );
          if (null != selectedVal) {
            userConfigProvider.setConfigValue(
                UserPreference.DEFAULT_TRADING_OPTION, selectedVal);
          }
        },
        suffixType: SettingsPageSuffixType.Nothing,
        height: 55,
      ),
      SettingsPageListItem(
        title: 'Default Exchange',
        subtitle: defaultTradeExchange.name,
        icon: FlutterIcons.exchange,
        onClick: () async {
          TradeExchange selectedVal = await showDialog(
            builder: (context) => ChooseAlertDialog<TradeExchange>(
              options: EnumsAsList.getTradeExchanges(),
              value: defaultTradeExchange,
              title: 'Select Trade Exchange',
              heightFactor: 0.15,
            ),
            context: context,
          );
          if (null != selectedVal) {
            userConfigProvider.setConfigValue(
              UserPreference.DEFAULT_EXCHANGE,
              selectedVal,
            );
          }
        },
        suffixType: SettingsPageSuffixType.Nothing,
        height: 55,
      ),
      SettingsPageListItem(
        title: 'Default Account',
        subtitle: accountProvider.getAccountName(defaultAccount),
        icon: Icons.account_balance_wallet,
        onClick: () async {
          int selectedVal = await showDialog(
            builder: (context) {
              var accounts = accountProvider.accounts;
              return ChooseAlertDialog<int>(
                options: accounts
                    .map((account) => Option<int>(
                          label: account.accountName,
                          value: account.id,
                        ))
                    .toList(),
                value: defaultAccount,
                title: 'Select Account',
              );
            },
            context: context,
          );
          if (null != selectedVal) {
            userConfigProvider.setConfigValue(
              UserPreference.DEFAULT_ACCOUNT,
              selectedVal,
            );
          }
        },
        suffixType: SettingsPageSuffixType.Nothing,
        height: 55,
      ),
      SettingsPageListItem(
        title: 'Use multiple accounts',
        icon: Icons.assignment,
        toggle: useMultipleAccounts,
        onClick: () {
          userConfigProvider.setConfigValue(
            UserPreference.USE_MULTIPLE_ACCOUNTS,
            !useMultipleAccounts,
          );
        },
        suffixType: SettingsPageSuffixType.Toggle,
      ),
    ];
  }

  List<Widget> _buildAccountsManagement(context) {
    return [
      SettingsPageListItem(header: true, title: 'Accounts Management'),
      SettingsPageListItem(
        title: 'Accounts',
        icon: Icons.account_balance,
        onClick: () {
          Navigator.of(context).pushNamed(AccountsManagementView);
        },
      ),
    ];
  }

  List<Widget> _buildManageTaxesCharges(context) {
    return [
      SettingsPageListItem(header: true, title: 'Taxes & Charges'),
      SettingsPageListItem(
        title: 'Security Transaction Tax',
        onClick: () {
          Navigator.of(context).pushNamed(SecurityTransactionTaxView);
        },
        icon: FlutterIcons.security_transaction,
      ),
      SettingsPageListItem(
        title: 'Exchange Tx Charges',
        onClick: () {
          Navigator.of(context).pushNamed(ExchangeTransactionsView);
        },
        icon: FlutterIcons.exchange_transaction,
      ),
      SettingsPageListItem(
        title: 'GST',
        onClick: () {
          Navigator.of(context).pushNamed(GSTView);
        },
        icon: FlutterIcons.gst,
      ),
      SettingsPageListItem(
        title: 'SEBI Charges',
        onClick: () {
          Navigator.of(context).pushNamed(SEBIChargesView);
        },
        icon: FlutterIcons.sebi,
      ),
      SettingsPageListItem(
        title: 'Stamp Duty Charges',
        onClick: () {
          Navigator.of(context).pushNamed(StampDutyChargesView);
        },
        icon: FlutterIcons.stamp_duty,
      ),
    ];
  }

  List<Widget> _buildSettings(context) {
    return [
      SettingsPageListItem(header: true, title: 'Settings'),
      // SettingsPageListItem(
      //   title: 'Backup',
      //   icon: Icons.cloud_upload,
      //   onClick: () {
      //     Navigator.of(context).pushNamed(BackupView);
      //   },
      // ),
      SettingsPageListItem(
        title: 'Help',
        icon: Icons.feedback,
      ),
      SettingsPageListItem(
        title: 'Review',
        icon: Icons.rate_review,
        onClick: () {
          Navigator.of(context).pushNamed(ReviewView);
        },
      )
    ];
  }
}
