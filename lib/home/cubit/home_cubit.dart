import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeTransactionsLoading());

  double totalBalance = 0.0;
  double totalExpense = 0.0;
  double totalIncome = 0.0;

  void getTotalBalance() async {
    try {
      totalBalance = await DatabaseHelper.getTotalBalance();
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void loadTransactions() async {
    try {
      final transactions = await DatabaseHelper.getAllTransactionRecords();
      if (transactions != null && transactions.isNotEmpty) {
        emit(HomeTransactionsLoaded(transactions));
      } else {
        emit(HomeNoTransactions());
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void getTotalRecordTypeAmount() async {
    try {
      totalExpense =
          await DatabaseHelper.getTotalAmountByRecordType(RecordType.expense);
      totalIncome =
          await DatabaseHelper.getTotalAmountByRecordType(RecordType.income);
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
