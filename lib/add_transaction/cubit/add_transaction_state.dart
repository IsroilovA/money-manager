part of 'add_transaction_cubit.dart';

@immutable
sealed class AddTransactionState {}

final class AddTransactionInitial extends AddTransactionState {}

final class RecordTypeChanged extends AddTransactionState {
  final RecordType recordType;

  RecordTypeChanged(this.recordType);
}
