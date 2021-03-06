import 'package:flutter/material.dart';
import 'package:stockcalculator/utils/app_theme.dart';
import 'package:stockcalculator/widgets/routes/app_router.dart';
import 'package:stockcalculator/widgets/routes/routes.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Calculator',
      theme: AppThemeData.getAppThemeData(context),
      darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      initialRoute: RootView,
      routes: {
        RootView: (_) => AppRouter(),
        // SettingsView: (_) => SettingsPage(),
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => AppRouter()),
    );
  }
}
