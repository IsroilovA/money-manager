import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_manager/data/models/transaction_record.dart';

part 'add_transaction_state.dart';

/// A Cubit to manage the state of adding a transaction.
class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit() : super(AddTransactionInitial());

  /// The current record type being managed by the cubit.
  RecordType recordType = RecordType.income;

  /// Selects the record type based on the given index and emits the corresponding state.
  void selectRecordType(int index) {
    switch (index) {
      case 0:
        {
          recordType = RecordType.income;
          break;
        }
      case 1:
        {
          recordType = RecordType.expense;
          break;
        }
      case 2:
        {
          recordType = RecordType.transfer;
          break;
        }
      default:
        {
          throw ArgumentError('Invalid index for record type selection');
        }
    }
    emit(RecordTypeChanged(recordType));
  }
}
