import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/providers/account_provider.dart';
import 'package:stockcalculator/providers/app_user_config_provider.dart';
import 'package:stockcalculator/providers/fee_config_provider.dart';
import 'package:stockcalculator/screens/calculator_screen.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/common/flutter_icons.dart';
import 'package:stockcalculator/widgets/routes/settings_router.dart';

class AppRouter extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<AppRouter> {
  final Map<TabItem, Map<String, Object>> _navItems = {
    TabItem.CALCULATOR: {
      'icon': FlutterIcons.calculate,
      'title': 'Calculator',
      'pageTitle': 'Stock Calculator',
      'key': GlobalKey<NavigatorState>(),
    },
    // TabItem.ACCOUNTS: {
    //   'icon': Icons.insert_chart,
    //   'title': 'Accounts',
    //   'pageTitle': 'Accounts',
    //   'key': GlobalKey<NavigatorState>(),
    // },
    TabItem.SETTINGS: {
      'icon': Icons.settings,
      'title': 'Settings',
      'pageTitle': 'Settings',
      'key': GlobalKey<NavigatorState>(),
    },
  };

  TabItem _currentTab = TabItem.CALCULATOR;

  Widget _renderPage(BuildContext context) {
    Map<String, Object> item = _navItems[_currentTab];
    var key = item['key'] as GlobalKey<NavigatorState>;
    var pageTitle = item['pageTitle'] as String;
    switch (_currentTab) {
      case TabItem.CALCULATOR:
        return CalculatorScreen(
          key: key,
          title: pageTitle,
        );
        break;
      // case TabItem.ACCOUNTS:
      //   return AccountsPage(
      //     key: key,
      //     title: pageTitle,
      //   );
      //   break;
      case TabItem.SETTINGS:
        return SettingsRouter(
          navigatorKey: key,
        );
        break;
      default:
        return CalculatorScreen(
          key: key,
          title: pageTitle,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool flag = true;
        try {
          final isFirstRouteInCurrentTab =
              await (_navItems[_currentTab]['key'] as GlobalKey<NavigatorState>)
                  .currentState
                  .maybePop();
          if (isFirstRouteInCurrentTab) {
            _onTabSelect(_currentTab);
            flag = false;
          }
        } catch (e) {}
        return flag;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AppUserConfigProvider>(
            create: (_) => AppUserConfigProvider(),
          ),
          ChangeNotifierProvider<FeeConfigProvider>(
            create: (_) => FeeConfigProvider(),
          ),
          ChangeNotifierProvider<AccountProvider>(
            create: (_) => AccountProvider(),
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.red,
          body: _renderPage(context),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            onTap: (index) => _onTabSelect(TabItem.values[index]),
            currentIndex: _currentTab.index,
            elevation: 5,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(tabItem: TabItem.CALCULATOR),
              // _buildNavItem(tabItem: TabItem.ACCOUNTS),
              _buildNavItem(tabItem: TabItem.SETTINGS),
            ],
          ),
        ),
      ),
    );
  }

  _onTabSelect(TabItem tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  BottomNavigationBarItem _buildNavItem({TabItem tabItem}) {
    return BottomNavigationBarItem(
      icon: Icon(_navItems[tabItem]['icon']),
      label: _navItems[tabItem]['title'],
    );
  }
}
