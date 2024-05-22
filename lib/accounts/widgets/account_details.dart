import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/accounts/cubit/account_details_cubit.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

/// A screen displaying the details of a specific account, including its transactions.
class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key, required this.account});
  final Account account;

  @override
  Widget build(BuildContext context) {
    // Load accounts when this screen is built.
    BlocProvider.of<TabsCubit>(context).loadAccounts();

    /// Confirms the deletion of the account and all related transactions.
    void confirmDeletion() {
      showWarningAlertDialog(
        context: context,
        text:
            "Are you sure you want to delete the Account and all the records related to it?",
        onYesClicked: () {
          // Delete the account and all related transactions
          BlocProvider.of<AccountDetailsCubit>(context).deleteAccount(account);
          // Pop the confirmation dialog
          Navigator.pop(context);
          // Pop the account details screen
          Navigator.pop(context);
        },
      );
    }

    /// Builds the account details screen with account info and transaction records.
    Widget buildAccountDetailsScreen(
        Account account, List<TransactionRecord>? transactionRecords) {
      return Column(
        children: [
          // Display account balance
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
          // Display account transactions heading
          Text(
            "Account transactions",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          const SizedBox(height: 20),
          // Display transaction records or a message if there are no transactions
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
          // Delete account button
          IconButton(
              onPressed: confirmDeletion, icon: const Icon(Icons.delete)),
          // Edit account button
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
            // Rebuild the UI when certain states are emitted
            if (current is TabsTransactionDeleted ||
                current is TabsAccountsLoaded ||
                current is TabsTransactionAdded ||
                current is TabsLoading) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            // Handle different states and display appropriate UI
            if (state is TabsTransactionDeleted ||
                state is TabsTransactionAdded ||
                state is TabsAccountsLoaded) {
              BlocProvider.of<AccountDetailsCubit>(context)
                  .loadAccountTransaction(account.id);
              return BlocBuilder<AccountDetailsCubit, AccountDetailsState>(
                builder: (context, state) {
                  if (state is AccountTransactionsLoaded) {
                    // Display account details with transaction records
                    return buildAccountDetailsScreen(
                        state.account, state.transactionRecords);
                  } else if (state is AccountDetailsInitial) {
                    // Load account transactions initially
                    BlocProvider.of<AccountDetailsCubit>(context)
                        .loadAccountTransaction(account.id);
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is AccountEdited) {
                    // Display account details after editing
                    return buildAccountDetailsScreen(
                        state.account, state.transactionRecords);
                  } else if (state is NoAccountTransactions) {
                    // Display account details with no transactions
                    return buildAccountDetailsScreen(account, null);
                  } else if (state is AccountDetailsError) {
                    // Display error message
                    return Center(
                      child: Text("Error: ${state.message}"),
                    );
                  } else {
                    // Display generic error message
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                },
              );
            } else if (state is TabsLoading) {
              // Display loading indicator
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              // Display generic error message
              return Center(
                child: Text(
                  "Something went wrong",
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
