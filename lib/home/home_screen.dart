import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/all_transactions/transactions_list_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/home/widgets/balance_card.dart';
import 'package:money_manager/home/widgets/record_item.dart';
import 'package:money_manager/home/widgets/top_spending_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.account});

  final Account account;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Widget buildTransactionsList(
        List<TransactionRecord> transactionRecords, bool isLoading) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => TransactionsListScreen(
                        transactionRecords: transactionRecords,
                      ),
                    ),
                  );
                },
                child: const Text("View all"),
              )
            ],
          ),
          if (isLoading && transactionRecords.isEmpty)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          if (transactionRecords.isEmpty && !isLoading)
            Center(
              child: Text(
                "No records yet",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
          if (transactionRecords.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  transactionRecords.length < 5 ? transactionRecords.length : 5,
              itemBuilder: (context, index) {
                final record = transactionRecords[index];
                return RecordItem(
                  record: record,
                  onRecordDeleted: (value) {
                    BlocProvider.of<HomeCubit>(context)
                        .deleteTransaction(value);
                  },
                );
              },
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            BalanceCard(account: widget.account),
            const SizedBox(height: 20),
            Text(
              "Top Spendings",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopSpendingCard(
                    icon: Icons.soup_kitchen_outlined, category: "Food"),
                TopSpendingCard(
                    icon: Icons.local_gas_station_outlined, category: "Fuel"),
                TopSpendingCard(
                    icon: Icons.luggage_outlined, category: "Travel"),
                TopSpendingCard(
                    icon: Icons.shopping_cart_outlined, category: "Shopping"),
              ],
            ),
            const SizedBox(height: 20),
            BlocProvider(
              create: (context) => HomeCubit(),
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is HomeTransactionsDeleted) {
                    setState(
                      () {},
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Transaction deleted"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  BlocProvider.of<HomeCubit>(context).loadTransactions();
                  if (state is HomeTransactionsLoading) {
                    return buildTransactionsList([], true);
                  } else if (state is HomeNoTransactions) {
                    return buildTransactionsList([], false);
                  } else if (state is HomeTransactionsLoaded) {
                    return buildTransactionsList(
                        state.transactionRecords, false);
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  } else if (state is HomeTransactionsDeleted) {
                    return buildTransactionsList(
                        state.transactionRecords, false);
                  } else {
                    return const Center(child: Text("Something is wrond"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
