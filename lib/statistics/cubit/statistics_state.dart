part of 'statistics_cubit.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsDataLoaded extends StatisticsState {
  final List<PieChartData> pieChartExpense;
  final List<PieChartData> pieChartIncome;
  final List<LineChartData> lineChartExpense;
  final List<LineChartData> lineChartIncome;
  StatisticsDataLoaded(
      {required this.pieChartExpense,
      required this.pieChartIncome,
      required this.lineChartExpense,
      required this.lineChartIncome});
}

final class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}
