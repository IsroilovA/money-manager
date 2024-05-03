part of 'tabs_cubit.dart';

@immutable
sealed class TabsState {}

final class TabsInitial extends TabsState {
  TabsInitial();
}

final class TabsLoaded extends TabsState {
  final Account account;
  TabsLoaded(this.account);
}

final class TabsNoAccounts extends TabsState {
  TabsNoAccounts();
}

class TabsError extends TabsState {
  final String message;

  TabsError(this.message);
}

class TabsPageChanged extends TabsState {
  final Account account;
  final int pageIndex;
  TabsPageChanged(this.pageIndex, this.account);
}

class TabsTransactionAdded extends TabsState {
  final Account account;
  final int pageIndex;

  TabsTransactionAdded(this.account, this.pageIndex);
}
