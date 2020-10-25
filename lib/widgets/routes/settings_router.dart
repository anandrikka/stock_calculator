import 'package:flutter/material.dart';
import 'package:stockcalculator/screens/about_screen.dart';
import 'package:stockcalculator/screens/account_management_screen.dart';
import 'package:stockcalculator/screens/add_or_edit_account_screen.dart';
import 'package:stockcalculator/screens/buy_and_sell_fee_screen.dart';
import 'package:stockcalculator/screens/default_fees_page.dart';
import 'package:stockcalculator/screens/exchange_fees_screen.dart';
import 'package:stockcalculator/screens/gst_screen.dart';
import 'package:stockcalculator/screens/review_options_screen.dart';
import 'package:stockcalculator/screens/settings_landing_screen.dart';
import 'package:stockcalculator/screens/single_fee_screen.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/dummy_view.dart';
import 'package:stockcalculator/widgets/routes/routes.dart';

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
      GSTView: (ctx) => GstScreen(),
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
      ReviewView: (ctx) => ReviewOptionsScreen(),
      AboutView: (ctx) => AboutScreen()
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
