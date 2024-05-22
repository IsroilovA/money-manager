import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_account/add_edit_account_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'account_details_state.dart';

/// A Cubit to manage the state of account details.
class AccountDetailsCubit extends Cubit<AccountDetailsState> {
  AccountDetailsCubit() : super(AccountDetailsInitial());

  /// Loads the transaction records for a specific account.
  void loadAccountTransaction(String accountId) async {
    emit(AccountDetailsLoading());
    try {
      final transactionRecords =
          await DatabaseHelper.getAccountTransactionRecords(accountId);
      final account = await DatabaseHelper.getAccountById(accountId);
      emit(AccountTransactionsLoaded(account, transactionRecords));
    } catch (e) {
      emit(AccountDetailsError(e.toString()));
    }
  }

  /// Navigates to the edit account screen and updates the account details if edited.
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
        final transactionRecords =
            await DatabaseHelper.getAccountTransactionRecords(accountId);
        emit(AccountEdited(editedAccount, transactionRecords));
      } catch (e) {
        emit(AccountDetailsError(e.toString()));
      }
    }
  }

  /// Deletes the specified account.
  void deleteAccount(Account account) async {
    try {
      await DatabaseHelper.deleteAccount(account);
    } catch (e) {
      emit(AccountDetailsError(e.toString()));
    }
  }
}
