import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/add_transaction/add_transaction_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'tabs_state.dart';

class TabsCubit extends Cubit<TabsState> {
  TabsCubit() : super(TabsInitial());

  void loadAccounts() async {
    try {
      final accounts = await DatabaseHelper.getAllAccounts();
      if (accounts != null && accounts.isNotEmpty) {
        emit(TabsLoaded(accounts));
      } else {
        emit(TabsNoAccounts());
      }
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  void selectPage(int index) async {
    final accounts = await DatabaseHelper.getAllAccounts();
    emit(TabsPageChanged(index, accounts!));
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
        await DatabaseHelper.updateAccountBalanceTransfer(newTransaction);
      } else {
        await DatabaseHelper.addTransationRecord(newTransaction);
      }
      final accounts = await DatabaseHelper.getAllAccounts();
      if (accounts != null && accounts.isNotEmpty) {
        emit(TabsTransactionAdded(accounts, pageIndex));
      } else {
        emit(TabsNoAccounts());
      }
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }
}
