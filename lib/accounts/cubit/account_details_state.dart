part of 'account_details_cubit.dart';

@immutable
sealed class AccountDetailsState {}

final class AccountDetailsInitial extends AccountDetailsState {}

final class AccountTransactionsLoaded extends AccountDetailsState {
  final List<TransactionRecord> transactionRecords;
  AccountTransactionsLoaded(this.transactionRecords);
}

final class AccountEdited extends AccountDetailsState {
  final Account account;

  AccountEdited(this.account);
}

final class AccountDetailsLoading extends AccountDetailsState {}

final class NoAccountTransactions extends AccountDetailsState {}

final class AccountDetailsError extends AccountDetailsState {
  final String message;
  AccountDetailsError(this.message);
}
