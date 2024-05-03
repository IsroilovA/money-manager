part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeTransactionsLoading extends HomeState {}

final class HomeNoTransactions extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

final class HomeTransactionsLoaded extends HomeState {
  final List<TransactionRecord> transactionRecords;

  HomeTransactionsLoaded(this.transactionRecords);
}

final class HomeTransactionsDeleted extends HomeState {
  final List<TransactionRecord> transactionRecords;
  HomeTransactionsDeleted(this.transactionRecords);
}
