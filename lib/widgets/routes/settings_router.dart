import 'package:flutter/material.dart';
import 'package:stock_calculator/screens/account_management_screen.dart';
import 'package:stock_calculator/screens/add_or_edit_account_screen.dart';
import 'package:stock_calculator/screens/buy_and_sell_fee_screen.dart';
import 'package:stock_calculator/screens/default_fees_page.dart';
import 'package:stock_calculator/screens/exchange_fees_screen.dart';
import 'package:stock_calculator/screens/settings_landing_screen.dart';
import 'package:stock_calculator/screens/single_fee_screen.dart';
import 'package:stock_calculator/utils/enums.dart';
import 'package:stock_calculator/widgets/dummy_view.dart';
import 'package:stock_calculator/widgets/routes/routes.dart';

class SettingsRouter extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  SettingsRouter({this.navigatorKey});

  @override
  _SettingsRouterState createState() => _SettingsRouterState();
}

class _SettingsRouterState extends State<SettingsRouter> {
  Map<String, WidgetBuilder> _routeBuilders() {
    return {
      SettingsView: (ctx) => SettingsLandingScreen(title: 'Settings'),
      AccountsManagementView: (ctx) =>
          AccountManagementScreen(title: 'Accounts'),
      SecurityTransactionTaxView: (ctx) => BuyAndSellFeeScreen(
            title: 'Security Tx Charges',
            feeType: FeeType.SECURITY_TRANSACTION_TAX,
          ),
      ExchangeTransactionsView: (ctx) =>
          ExchangeFeesScreen(title: 'Exchange Tx View'),
      GSTView: (ctx) => SingleFeeScreen(
            title: 'GST',
            feeType: FeeType.GST,
          ),
      SEBIChargesView: (ctx) => SingleFeeScreen(
            title: 'SEBI',
            feeType: FeeType.SEBI,
          ),
      StampDutyChargesView: (ctx) => BuyAndSellFeeScreen(
            title: 'StampDuty',
            feeType: FeeType.STAMP_DUTY,
          ),
      ClearingChargesView: (ctx) => DefaultFeesPage(title: 'Clearning Charges'),
      BackupView: (ctx) => DummyView(title: 'Backup'),
      AddOrEditAccountView: (ctx) => AddOrEditAccountScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (ctx) => routeBuilders[routeSettings.name](ctx),
        );
      },
    );
  }
}