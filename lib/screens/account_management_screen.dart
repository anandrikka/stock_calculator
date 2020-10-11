import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/providers/account_provider.dart';
import 'package:stockcalculator/widgets/routes/routes.dart';

class AccountManagementScreen extends StatelessWidget {
  final String title;

  AccountManagementScreen({this.title});

  static const String MODE_ADD = 'ADD';
  static const String MODE_EDIT = 'EDIT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddOrEditAccountView,
            arguments: {'mode': MODE_ADD, 'data': AccountEntity.create()},
          );
        },
      ),
      body: Consumer<AccountProvider>(
        builder: (_, ap, __) {
          var accounts = ap.accounts;
          return ListView.builder(
            itemBuilder: (_, index) {
              var account = accounts[index];
              return ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AddOrEditAccountView,
                    arguments: {'mode': MODE_EDIT, 'data': account},
                  );
                },
                dense: true,
                title: Text(
                  account.accountName,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                leading: CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      account.accountName.substring(0, 2).toUpperCase(),
                    ),
                  ),
                ),
              );
            },
            itemCount: accounts.length,
          );
        },
      ),
    );
  }
}
