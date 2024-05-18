part of 'tabs_cubit.dart';

@immutable
sealed class TabsState {}

final class TabsInitial extends TabsState {
  TabsInitial();
}

final class TabsLoading extends TabsState {
  TabsLoading();
}

final class TabsAccountsLoaded extends TabsState {
  final List<Account> accounts;
  TabsAccountsLoaded(this.accounts);
}


final class TabsNoAccounts extends TabsState {
  TabsNoAccounts();
}

final class TabsError extends TabsState {
  final String message;

  TabsError(this.message);
}

final class TabsPageChanged extends TabsState {
  final int pageIndex;
  TabsPageChanged(this.pageIndex);
}

final class TabsTransactionAdded extends TabsState {
  final int pageIndex;

  TabsTransactionAdded(this.pageIndex);
}


final class TabsTransactionDeleted extends TabsState {
  final TransactionRecord transactionRecord;
  TabsTransactionDeleted(this.transactionRecord);
}
