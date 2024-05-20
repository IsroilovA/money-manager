import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/accounts/cubit/account_details_cubit.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key, required this.account});
  final Account account;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TabsCubit>(context).loadAccounts();
    void confirmDelition() {
      showWarningAlertDialog(
        context: context,
        text:
            "Are you sure you want to delete the Account and all the records related to it?",
        onYesClicked: () {
          BlocProvider.of<AccountDetailsCubit>(context).deleteAccount(account);
          //pop dialog itself
          Navigator.pop(context);
          //pop details screen
          Navigator.pop(context);
        },
      );
    }

    Widget buildAccountDetailsScreen(
        Account account, List<TransactionRecord>? transactionRecords) {
      return Column(
        children: [
          ListTile(
            titleTextStyle: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
            leading: const Icon(
              Icons.account_balance_wallet,
              size: 50,
            ),
            title: const Text("Balance: "),
            trailing: Text(
              account.formattedBalance,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: account.balance >= 0 ? Colors.green : Colors.red,
                  ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "Account transactions",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          const SizedBox(height: 20),
          transactionRecords == null
              ? Text(
                  "No Account transactions",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                )
              : Expanded(
                  child: BlocProvider.value(
                    value: BlocProvider.of<TabsCubit>(context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: transactionRecords.length,
                      itemBuilder: (context, index) {
                        return RecordItem(
                          transactionRecord: transactionRecords[index],
                        );
                      },
                    ),
                  ),
                )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: confirmDelition, icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () {
                BlocProvider.of<AccountDetailsCubit>(context)
                    .editAccount(context, account.id);
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<TabsCubit, TabsState>(
          buildWhen: (previous, current) {
            if (current is TabsTransactionDeleted ||
                current is TabsAccountsLoaded ||
                current is TabsTransactionAdded ||
                current is TabsLoading) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is TabsTransactionDeleted ||
                state is TabsTransactionAdded ||
                state is TabsAccountsLoaded) {
              BlocProvider.of<AccountDetailsCubit>(context)
                  .loadAccountTransaction(account.id);
              return BlocBuilder<AccountDetailsCubit, AccountDetailsState>(
                builder: (context, state) {
                  if (state is AccountTransactionsLoaded) {
                    return buildAccountDetailsScreen(
                        state.account, state.transactionRecords);
                  } else if (state is AccountDetailsInitial) {
                    BlocProvider.of<AccountDetailsCubit>(context)
                        .loadAccountTransaction(account.id);
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is AccountEdited) {
                    return buildAccountDetailsScreen(
                        state.account, state.transactionRecords);
                  } else if (state is NoAccountTransactions) {
                    return buildAccountDetailsScreen(account, null);
                  } else if (state is AccountDetailsError) {
                    return Center(
                      child: Text("Error: ${state.message}"),
                    );
                  } else {
                    return const Center(
                      child: Text("something went wrong"),
                    );
                  }
                },
              );
            } else if (state is TabsLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              return Center(
                child: Text(
                  "Something is wrong2",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
