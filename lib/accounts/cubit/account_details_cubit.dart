import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';

part 'account_details_state.dart';

class AccountDetailsCubit extends Cubit<AccountDetailsState> {
  AccountDetailsCubit() : super(AccountDetailsInitial());

  void loadAccountTransaction(Account account) async {
    try {
      final transactionRecords =
          await DatabaseHelper.getAccountTransactionRecords(account.id);
      if (transactionRecords != null && transactionRecords.isNotEmpty) {
        emit(AccountTransactionsLoaded(transactionRecords));
      } else {
        emit(NoAccountTransactions());
      }
    } catch (e) {
      AccountDetailsError(e.toString());
    }
  }
}
