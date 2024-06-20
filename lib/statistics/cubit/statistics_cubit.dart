import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/money_manager_repository.dart';

part 'statistics_state.dart';

// Class to represent data for a Pie Chart
class PieChartData {
  final String category;
  final double amount;

  PieChartData(this.category, this.amount);

  // Get the color associated with the category
  Color get color {
    return categoryColors.entries
        .firstWhere((element) => element.key.name == category)
        .value;
  }

  // Get the icon associated with the category
  IconData get icon {
    return categoryIcons.entries
        .firstWhere((element) => element.key.name == category)
        .value;
  }
}

// Class to represent data for a Line Chart
class LineChartData {
  final DateTime date;
  final double amount;

  LineChartData(this.date, this.amount);
}

// Cubit for managing the state of statistics in the application
class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({required MoneyManagerRepository moneyManagerRepository})
      : _moneyManagerRepository = moneyManagerRepository,
        super(StatisticsInitial());

  final MoneyManagerRepository _moneyManagerRepository;

  // Load records for the statistics based on the provided date ranges
  void loadRecords({
    required DateTimeRange incomePieChartRange,
    required DateTimeRange expensePieChartRange,
    required DateTimeRange expenseLineChartRange,
    required DateTimeRange incomeLineChartRange,
  }) async {
    try {
      final lineChartIncome = await _moneyManagerRepository
          .getTotalAmountByDate(incomeLineChartRange, RecordType.income);
      final lineChartExpense = await _moneyManagerRepository
          .getTotalAmountByDate(expenseLineChartRange, RecordType.expense);
      final pieChartExpenses = await _moneyManagerRepository
          .getTotalAmountByCategories(expensePieChartRange, RecordType.expense);
      final pieChartIncomes = await _moneyManagerRepository
          .getTotalAmountByCategories(incomePieChartRange, RecordType.income);

      emit(StatisticsDataLoaded(
          pieChartExpense: pieChartExpenses,
          pieChartIncome: pieChartIncomes,
          lineChartExpense: lineChartExpense,
          lineChartIncome: lineChartIncome));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
