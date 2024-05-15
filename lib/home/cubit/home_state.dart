part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeTransactionsLoading extends HomeState {}

final class HomeNoTransactions extends HomeState {}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

final class HomeTransactionsLoaded extends HomeState {
  final List<TransactionRecord> transactionRecords;

  HomeTransactionsLoaded(this.transactionRecords);
}
