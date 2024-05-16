part of 'account_details_cubit.dart';

@immutable
sealed class AccountDetailsState {}

final class AccountDetailsInitial extends AccountDetailsState {}

final class AccountTransactionsLoaded extends AccountDetailsState {
  final List<TransactionRecord>? transactionRecords;
  final Account account;
  AccountTransactionsLoaded(this.account, this.transactionRecords);
}

final class AccountEdited extends AccountDetailsState {
  final Account account;
  final List<TransactionRecord>? transactionRecords;
  AccountEdited(this.account, this.transactionRecords);
}

final class AccountDetailsLoading extends AccountDetailsState {}

final class NoAccountTransactions extends AccountDetailsState {}

final class AccountDetailsError extends AccountDetailsState {
  final String message;
  AccountDetailsError(this.message);
}
