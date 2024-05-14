import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/all_transactions/transactions_list_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/home/widgets/balance_card.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';
import 'package:money_manager/home/widgets/top_spending_card.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.accounts});

  final List<Account> accounts;

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
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => TransactionsListScreen(
                        accounts: widget.accounts,
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
                  accounts: widget.accounts,
                  transactionRecord: record,
                );
              },
            ),
        ],
      );
    }

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              const BalanceCard(),
              const SizedBox(height: 20),
              Text(
                "Top Spendings",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground),
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
              BlocBuilder<TabsCubit, TabsState>(
                buildWhen: (previous, current) {
                  if (current is TabsTransactionDeleted ||
                      current is TabsLoaded ||
                      current is TabsLoading) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is TabsTransactionDeleted || state is TabsLoaded) {
                    return BlocBuilder<HomeCubit, HomeState>(
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
                        } else {
                          return const Center(
                              child: Text("Something is wrond"));
                        }
                      },
                    );
                  } else if (state is TabsLoading) {
                    return buildTransactionsList([], true);
                  } else {
                    return const Text("error");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
