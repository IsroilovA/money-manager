import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/accounts/cubit/account_details_cubit.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails(
      {super.key, required this.account, required this.accounts});
  final Account account;
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    Widget buildAccountDetailsScreen(
        Account account, List<TransactionRecord>? transactionRecords) {
      return Column(
        children: [
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text("Balance: "),
            trailing: Text(account.formattedBalance),
          ),
          const SizedBox(height: 10),
          Text(
            "Account transactions",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          const SizedBox(height: 10),
          transactionRecords == null
              ? Text(
                  "No Account transactions",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: transactionRecords.length,
                  itemBuilder: (context, index) {
                    return RecordItem(
                        transactionRecord: transactionRecords[index],
                        accounts: accounts);
                  },
                )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: BlocProvider(
        create: (context) => AccountDetailsCubit(),
        child: BlocBuilder<AccountDetailsCubit, AccountDetailsState>(
          builder: (context, state) {
            if (state is AccountTransactionsLoaded) {
              return buildAccountDetailsScreen(
                  account, state.transactionRecords);
            } else if (state is AccountDetailsInitial) {
              BlocProvider.of<AccountDetailsCubit>(context)
                  .loadAccountTransaction(account);
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
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
        ),
      ),
    );
  }
}
