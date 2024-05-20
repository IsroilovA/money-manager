import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_account/add_edit_account_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'account_details_state.dart';

class AccountDetailsCubit extends Cubit<AccountDetailsState> {
  AccountDetailsCubit() : super(AccountDetailsInitial());

  List<TransactionRecord>? transactionRecords;

  void loadAccountTransaction(String accountId) async {
    try {
      transactionRecords =
          await DatabaseHelper.getAccountTransactionRecords(accountId);
      final account = await DatabaseHelper.getAccountById(accountId);
      emit(AccountTransactionsLoaded(account, transactionRecords));
    } catch (e) {
      AccountDetailsError(e.toString());
    }
  }

  void editAccount(BuildContext context, String accountId) async {
    final account = await DatabaseHelper.getAccountById(accountId);
    if (context.mounted) {
      final editedAccount = await Navigator.of(context).push<Account>(
        MaterialPageRoute(
          builder: (ctx) => AddEditAccountScreen(account: account),
        ),
      );
      if (editedAccount == null) {
        return;
      }
      try {
        await DatabaseHelper.editAccount(editedAccount, account.balance);
        emit(AccountEdited(editedAccount, transactionRecords));
      } catch (e) {
        emit(AccountDetailsError(e.toString()));
      }
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
