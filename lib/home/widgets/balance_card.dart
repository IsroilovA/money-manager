import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/home/widgets/income_expense_widget.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title for the total balance
            Text(
              "Total Balance",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 25,
                  ),
            ),
            BlocBuilder<TabsCubit, TabsState>(
              buildWhen: (previous, current) {
                // Rebuild widget when transactions are added, deleted, or accounts are loaded
                if (current is TabsTransactionAdded ||
                    current is TabsTransactionDeleted ||
                    current is TabsLoading ||
                    current is TabsAccountsLoaded) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TabsTransactionAdded ||
                    state is TabsTransactionDeleted ||
                    state is TabsAccountsLoaded) {
                  // Fetch the total balance
                  BlocProvider.of<HomeCubit>(context).getTotalBalance();
                  double totalBalance =
                      context.select((HomeCubit cubit) => cubit.totalBalance);
                  return Text(
                    currencyFormatter.format(totalBalance),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  );
                } else if (state is TabsLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  return Text(
                    "Error",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            // Title for monthly expenses
            Text(
              "Monthly Expenses",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 20),
            // Widgets to display income and expenses
            BlocProvider(
              create: (context) => HomeCubit(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeExpenseWidget(isIncome: true),
                  IncomeExpenseWidget(isIncome: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
