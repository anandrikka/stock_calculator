import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  final String title;

  AccountsPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
        ),
      ),
      body: Container(
        child: Text('Accounts'),
      ),
    );
  }
}
