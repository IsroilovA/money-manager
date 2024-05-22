import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Load transactions from the database with an optional filter for record type
  void loadTransactions({RecordType? filter}) async {
    emit(HomeTransactionsLoading());
    try {
      List<TransactionRecord>? transactions;
      if (filter == null) {
        transactions = await DatabaseHelper.getAllTransactionRecords();
      } else {
        transactions =
            await DatabaseHelper.getTransactionRecordsByRecordType(filter);
      }
      if (transactions != null) {
        final totalBalance = await DatabaseHelper.getTotalBalance();
        final balancesByCategories =
            await DatabaseHelper.getTotalIncomeExpenseAmount();
        emit(HomeTransactionsLoaded(
            transactions, totalBalance, balancesByCategories));
      } else {
        emit(HomeNoTransactions());
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
