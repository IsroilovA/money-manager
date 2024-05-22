import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/all_transactions/transactions_list_screen.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/home/widgets/balance_card.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';
import 'package:money_manager/home/widgets/top_spending_card.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            // Balance card showing the total balance
            const BalanceCard(),
            const SizedBox(height: 20),
            // Section title for Top Spendings
            Text(
              "Top Spendings",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 18),
            // Row showing top spending categories
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
            // Section title for Recent Transactions with a button to view all
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
                    //on pressed navigato to TransactionsList with cubits passed
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: BlocProvider.of<TabsCubit>(context),
                            ),
                            BlocProvider(
                              create: (context) => HomeCubit(),
                            )
                          ],
                          child: const TransactionsListScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text("View all"),
                )
              ],
            ),
            // BlocBuilder to manage the state of the transactions
            BlocBuilder<TabsCubit, TabsState>(
              buildWhen: (previous, current) {
                if (current is TabsTransactionDeleted ||
                    current is TabsAccountsLoaded ||
                    current is TabsLoading ||
                    current is TabsTransactionAdded) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TabsTransactionDeleted ||
                    state is TabsAccountsLoaded ||
                    state is TabsTransactionAdded) {
                  // Load transactions if the state indicates changes
                  BlocProvider.of<HomeCubit>(context).loadTransactions();
                  return BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeInitial) {
                        BlocProvider.of<HomeCubit>(context).loadTransactions();
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (state is HomeTransactionsLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (state is HomeNoTransactions) {
                        return Center(
                          child: Text(
                            "No records yet",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        );
                      } else if (state is HomeTransactionsLoaded) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.transactionRecords.length < 5
                              ? state.transactionRecords.length
                              : 5,
                          itemBuilder: (context, index) {
                            return RecordItem(
                                transactionRecord:
                                    state.transactionRecords[index]);
                          },
                        );
                      } else if (state is HomeError) {
                        return Center(
                          child: Text(
                            "Error: ${state.message}",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text("Something went wrong"));
                      }
                    },
                  );
                } else if (state is TabsLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  return const Text("Error");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
