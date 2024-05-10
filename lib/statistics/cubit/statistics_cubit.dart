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

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitial());

  void loadRecords() async {
    try {
      final expenses =
          await DatabaseHelper.getTotalAmountByCategories(RecordType.expense);
      final incomes =
          await DatabaseHelper.getTotalAmountByCategories(RecordType.income);
      emit(StatisticsPieChartDataLoaded(
          expenseTransactionsRecords: expenses,
          incomeTransactionsRecords: incomes));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
