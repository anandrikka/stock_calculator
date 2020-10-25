import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            arguments: {'mode': MODE_ADD},
          );
        },
      ),
      body: Consumer<AccountProvider>(
        builder: (_, ap, __) {
          var accountOptions = ap.accountOptions;
          // var accounts = ap.accounts;
          return ListView.builder(
            itemBuilder: (_, index) {
              var option = accountOptions[index];
              return Dismissible(
                key: ValueKey(index),
                background: Container(
                  color: Theme.of(context).errorColor,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ap.removeAccount(option.value);
                },
                confirmDismiss: (_) {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('Do you want to delete account ?'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                              ),
                              FlatButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                              )
                            ],
                          ));
                },
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AddOrEditAccountView,
                      arguments: {'mode': MODE_EDIT, 'accountId': option.value},
                    );
                  },
                  dense: true,
                  title: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        option.label.substring(0, 2).toUpperCase(),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: accountOptions.length,
          );
        },
      ),
    );
  }
}
