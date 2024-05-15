import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/add_new_account/add_account_screen.dart';
import 'package:money_manager/add_transaction/add_transaction_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'tabs_state.dart';

class TabsCubit extends Cubit<TabsState> {
  TabsCubit() : super(TabsInitial());

  int pageIndex = 0;

  // void checkForAccounts() async {
  //   try {
  //     final accountExists = await DatabaseHelper.hasAccounts();
  //     if (accountExists) {
  //       emit(TabsLoaded());
  //     } else {
  //       emit(TabsNoAccounts());
  //     }
  //   } catch (e) {
  //     emit(TabsError(e.toString()));
  //   }
  // }

  Future<double> getAccountBalance(String id) async {
    return (await DatabaseHelper.getAccountById(id)).balance;
  }

  void loadAccounts() async {
    try {
      final accounts = await DatabaseHelper.getAllAccounts();
      if (accounts != null && accounts.isNotEmpty) {
        emit(TabsAccountsLoaded(accounts));
      } else {
        emit(TabsNoAccounts());
      }
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  void selectPage(int index) async {
    pageIndex = index;
    emit(TabsPageChanged(index));
  }

  int get index => pageIndex;

  void deleteTransaction(TransactionRecord transactionRecord) async {
    emit(TabsLoading());
    try {
      await DatabaseHelper.deleteTransationRecord(transactionRecord);
      emit(TabsTransactionDeleted());
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  void addTtansaction(BuildContext context, int pageIndex) async {
    final newTransaction = await Navigator.of(context).push<TransactionRecord>(
      MaterialPageRoute(
        builder: (ctx) => const AddNewTransaction(),
      ),
    );
    if (newTransaction == null) {
      return;
    }
    try {
      if (newTransaction.recordType == RecordType.transfer) {
        await DatabaseHelper.addTransferTransaction(newTransaction);
      } else {
        await DatabaseHelper.addTransationRecord(newTransaction);
      }
      emit(TabsTransactionAdded(pageIndex));
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  void addAccount(BuildContext context) async {
    final newAccount = await Navigator.of(context).push<Account>(
      MaterialPageRoute(
        builder: (ctx) => const AddNewAccountScreen(),
      ),
    );
    if (newAccount == null) {
      return;
    }
    try {
      await DatabaseHelper.addAccount(newAccount);
      pageIndex = 3;
      emit(TabsInitial());
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }
}
