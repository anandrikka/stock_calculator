import 'package:sqflite/sqflite.dart';
import 'package:stock_calculator/dao/account_dao.dart';
import 'package:stock_calculator/models/account_entity.dart';
import 'package:stock_calculator/repo/base_repository.dart';

class AccountRepository extends BaseRepository<int, AccountEntity> {
  final AccountDao _accountDao = AccountDao();

  @override
  create(AccountEntity t) async {
    try {
      int id = await _accountDao.create(t);
      return id;
    } on DatabaseException catch (e) {
      throw e;
    }
  }

  @override
  deleteById(int id) {
    _accountDao.deleteById(id);
  }

  @override
  Future<List<AccountEntity>> getAll() async {
    return _accountDao.getAll();
  }

  @override
  Future<AccountEntity> getById(int id) async {
    return _accountDao.getById(id);
  }

  @override
  update(AccountEntity t) {
    _accountDao.update(t);
  }

  Future<List<AccountEntity>> getAllActiveAccounts() async {
    return _accountDao.getAllActiveAccounts();
  }
}
