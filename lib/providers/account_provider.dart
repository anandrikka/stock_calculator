import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockcalculator/models/account_entity.dart';
import 'package:stockcalculator/repo/account_repository.dart';

class AccountProvider extends ChangeNotifier {
  bool _loaded = false;
  AccountRepository _accountRepo = AccountRepository();
  List<AccountEntity> _accounts = [];

  List<AccountEntity> get accounts => _accounts;

  bool get loaded => _loaded;

  AccountProvider() {
    _fetchAccounts();
  }

  _fetchAccounts() async {
    _accounts = await _accountRepo.getAllActiveAccounts();
    _loaded = true;
    notifyListeners();
  }

  createOrUpdateAccount(AccountEntity ae) async {
    try {
      if (ae.id != null) {
        await _accountRepo.update(ae);
      } else {
        await _accountRepo.create(ae);
      }
    } on DatabaseException catch (e) {
      throw e;
    }
    _fetchAccounts();
  }

  updateAccount(AccountEntity ae) async {
    await _accountRepo.update(ae);
    notifyListeners();
  }

  createAccount(AccountEntity ae) {
    _accountRepo.create(ae);
    _fetchAccounts();
  }

  getAccountName(int id) {
    var accounts = _accounts.where((account) => id == account.id);
    if (accounts.length > 0) {
      return accounts.single.accountName;
    }
    return '';
  }
}
