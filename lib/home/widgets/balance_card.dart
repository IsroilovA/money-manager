import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/home/widgets/income_expense_widget.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
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
            Text(
              "Total Balance",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 25,
                  ),
            ),
            BlocBuilder<TabsCubit, TabsState>(
              buildWhen: (previous, current) {
                if (current is TabsTransactionAdded ||
                    current is TabsTransactionDeleted ||
                    current is TabsAccountsLoaded) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TabsTransactionAdded ||
                    state is TabsTransactionDeleted ||
                    state is TabsAccountsLoaded) {
                  BlocProvider.of<HomeCubit>(context).getTotalBalance();
                  double totalBalance =
                      context.select((HomeCubit cubit) => cubit.totalBalance);
                  return Text(
                    currencyFormatter.format(totalBalance),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  );
                } else {
                  return Text(
                    "error",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Monthly Expenses",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IncomeExpenseWidget(isIncome: true),
                IncomeExpenseWidget(isIncome: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
