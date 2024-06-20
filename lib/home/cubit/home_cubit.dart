import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/money_manager_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required MoneyManagerRepository moneyManagerRepository})
      : _moneyManagerRepository = moneyManagerRepository,
        super(HomeInitial());

  final MoneyManagerRepository _moneyManagerRepository;

  // Load transactions from the database with an optional filter for record type
  void loadTransactions({RecordType? filter}) async {
    emit(HomeTransactionsLoading());
    try {
      List<TransactionRecord>? transactions;
      if (filter == null) {
        transactions = await _moneyManagerRepository.getAllTransactionRecords();
      } else {
        transactions = await _moneyManagerRepository
            .getTransactionRecordsByRecordType(filter);
      }
      final totalBalance = await _moneyManagerRepository.getTotalBalance();
      if (transactions != null) {
        final balancesByCategories =
            await _moneyManagerRepository.getTotalIncomeExpenseAmount();
        emit(HomeTransactionsLoaded(
            transactions, totalBalance, balancesByCategories));
      } else {
        emit(HomeNoTransactions(totalBalance));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
