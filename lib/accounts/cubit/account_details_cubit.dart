import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:money_manager/add_new_account/add_account_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'account_details_state.dart';

class AccountDetailsCubit extends Cubit<AccountDetailsState> {
  AccountDetailsCubit() : super(AccountDetailsInitial());

  void loadAccountTransaction(Account account) async {
    try {
      final transactionRecords =
          await DatabaseHelper.getAccountTransactionRecords(account.id);
      if (transactionRecords != null) {
        emit(AccountTransactionsLoaded(transactionRecords));
      } else {
        emit(NoAccountTransactions());
      }
    } catch (e) {
      AccountDetailsError(e.toString());
    }
  }

  void editAccount(BuildContext context, String accountId) async {
    final account = await DatabaseHelper.getAccountById(accountId);
    final editedAccount = await Navigator.of(context).push<Account>(
      MaterialPageRoute(
        builder: (ctx) => AddNewAccountScreen(account: account),
      ),
    );
    if (editedAccount == null) {
      return;
    }
    try {
      await DatabaseHelper.editAccount(editedAccount);
      final updatedGoal = await DatabaseHelper.getAccountById(accountId);
      final transactionRecords =
          await DatabaseHelper.getAccountTransactionRecords(account.id);
      emit(AccountEdited(updatedGoal, transactionRecords));
    } catch (e) {
      emit(AccountDetailsError(e.toString()));
    }
  }

  void deleteAccount(Account account) async {
    try {
      await DatabaseHelper.deleteAccount(account);
    } catch (e) {
      emit(AccountDetailsError(e.toString()));
    }
  }
}
