import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_account/add_edit_account_screen.dart';
import 'package:money_manager/add_transaction/add_edit_transaction_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'tabs_state.dart';

class TabsCubit extends Cubit<TabsState> {
  TabsCubit() : super(TabsInitial());

  int pageIndex = 0;
  List<Account> accounts = [];

  Future<double> getAccountBalance(String id) async {
    return (await DatabaseHelper.getAccountById(id)).balance;
  }

  void loadAccounts() async {
    try {
      final receivedAccounts = await DatabaseHelper.getAllAccounts();
      if (receivedAccounts != null) {
        accounts = receivedAccounts;
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
      emit(TabsTransactionDeleted(transactionRecord));
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  void addTransactionBack(TransactionRecord transactionRecord) async {
    try {
      if (transactionRecord.recordType == RecordType.transfer) {
        await DatabaseHelper.addTransferTransaction(transactionRecord);
      } else {
        await DatabaseHelper.addTransationRecord(transactionRecord);
      }
      emit(TabsTransactionAdded(pageIndex));
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  void addTtansaction(BuildContext context, int pageIndex) async {
    final newTransaction = await Navigator.of(context).push<TransactionRecord>(
      MaterialPageRoute(
        builder: (ctx) => BlocProvider.value(
          value: BlocProvider.of<TabsCubit>(context),
          child: const AddEditTransaction(),
        ),
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
        builder: (ctx) => const AddEditAccountScreen(),
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
