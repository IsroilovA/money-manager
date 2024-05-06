part of 'tabs_cubit.dart';

@immutable
sealed class TabsState {}

final class TabsInitial extends TabsState {
  TabsInitial();
}

final class TabsLoading extends TabsState {
  TabsLoading();
}

final class TabsLoaded extends TabsState {
  final List<Account> accounts;
  TabsLoaded(this.accounts);
}

final class TabsNoAccounts extends TabsState {
  TabsNoAccounts();
}

class TabsError extends TabsState {
  final String message;

  TabsError(this.message);
}

class TabsPageChanged extends TabsState {
  final List<Account> accounts;
  final int pageIndex;
  TabsPageChanged(this.pageIndex, this.accounts);
}

class TabsTransactionAdded extends TabsState {
  final List<Account> accounts;
  final int pageIndex;

  TabsTransactionAdded(this.accounts, this.pageIndex);
}

class TabsTransactionDeleted extends TabsState {
  final List<Account> accounts;

  TabsTransactionDeleted(this.accounts);
}
