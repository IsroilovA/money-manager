import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeTransactionsLoading());

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

  void deleteTransaction(TransactionRecord transactionRecord) async {
    emit(HomeTransactionsLoading());
    try {
      final transactions = await DatabaseHelper.getAllTransactionRecords();
      await DatabaseHelper.deleteTransationRecord(transactionRecord);
      if (transactions != null && transactions.isNotEmpty) {
        emit(HomeTransactionsDeleted(transactions));
      } else {
        emit(HomeNoTransactions());
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
