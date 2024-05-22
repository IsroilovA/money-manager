import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  double totalBalance = 0.0;
  Map<RecordType, double> balancesByCategories = {};

  // Fetch the total balance from the database
  void getTotalBalance() async {
    try {
      totalBalance = await DatabaseHelper.getTotalBalance();
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

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
        emit(HomeTransactionsLoaded(transactions));
      } else {
        emit(HomeNoTransactions());
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  // Fetch total amounts for income and expense record types
  void getTotalRecordTypeAmount() async {
    try {
      balancesByCategories = await DatabaseHelper.getTotalIncomeExpenseAmount();
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
