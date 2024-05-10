part of 'statistics_cubit.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsPieChartDataLoaded extends StatisticsState {
  final List<PieChartData> expenseTransactionsRecords;
  final List<PieChartData> incomeTransactionsRecords;
  StatisticsPieChartDataLoaded(
      {required this.expenseTransactionsRecords,
      required this.incomeTransactionsRecords});
}

final class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}
