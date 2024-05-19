import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_manager/data/models/transaction_record.dart';

part 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit() : super(AddTransactionInitial());

  RecordType recordType = RecordType.income;

  void selectRecordType(int index) {
    switch (index) {
      case 0:
        {
          recordType = RecordType.income;
        }
      case 1:
        {
          recordType = RecordType.expense;
        }
      case 2:
        {
          recordType = RecordType.transfer;
        }
    }
    emit(RecordTypeChanged(recordType));
  }
}
