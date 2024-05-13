import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'statistics_state.dart';

class PieChartData {
  PieChartData(this.category, this.amount);
  final String category;
  final double amount;
}

class LineChartData {
  LineChartData(this.date, this.amount);
  final DateTime date;
  final double amount;
}

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitial());

  void loadRecords() async {
    try {
      final lineChartIncome =
          await DatabaseHelper.getTotalAmountByDate(RecordType.income);
      final lineChartExpense =
          await DatabaseHelper.getTotalAmountByDate(RecordType.expense);
      final expenses =
          await DatabaseHelper.getTotalAmountByCategories(RecordType.expense);
      final incomes =
          await DatabaseHelper.getTotalAmountByCategories(RecordType.income);
      emit(StatisticsDataLoaded(
          pieChartExpense: expenses,
          pieChartIncome: incomes,
          lineChartExpense: lineChartExpense,
          lineChartIncome: lineChartIncome));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
