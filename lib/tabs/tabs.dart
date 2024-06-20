import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_account/add_edit_account_screen.dart';
import 'package:money_manager/goals/goals_screen.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/home/home_screen.dart';
import 'package:money_manager/services/locator.dart';
import 'package:money_manager/services/money_manager_repository.dart';
import 'package:money_manager/statistics/statistics_screen.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

// Main screen that handles navigation between different tabs
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((TabsCubit cubit) => cubit.pageIndex);
    String pageTitle = switch (selectedTab) {
      0 => "Home",
      1 => "Statistics",
      2 => "Goals",
      _ => throw UnimplementedError(),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
      ),
      body: BlocConsumer<TabsCubit, TabsState>(
        listener: (context, state) {
          if (state is TabsTransactionDeleted) {
            // Show a snackbar when a transaction is deleted
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Transaction deleted"),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    context
                        .read<TabsCubit>()
                        .addTransactionBack(state.transactionRecord);
                  },
                ),
              ),
            );
          } else if (state is TabsTransactionAdded) {
            // Show a snackbar when a transaction is added
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Transaction added"),
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is TabsNoAccounts) {
            // Navigate to the AddEditAccountScreen if no accounts are found
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AddEditAccountScreen(),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          if (current is TabsPageChanged ||
              current is TabsTransactionAdded ||
              current is TabsTransactionDeleted ||
              current is TabsLoading ||
              current is TabsNoAccounts) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is TabsInitial) {
            BlocProvider.of<TabsCubit>(context).loadAccounts();
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is TabsNoAccounts) {
            return const AddEditAccountScreen();
          } else if (state is TabsAccountsLoaded) {
            return IndexedStack(
              index: selectedTab,
              children: [
                BlocProvider(
                  create: (context) => HomeCubit(
                      moneyManagerRepository:
                          locator<MoneyManagerRepository>()),
                  child: const HomeScreen(),
                ),
                const StatisticsScreen(),
                const GoalsScreen(),
              ],
            );
          } else if (state is TabsError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            );
          } else {
            return const Center(child: Text("Something is wrong"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TabsCubit>().addTransaction(context, selectedTab);
        },
        shape: const CircleBorder(),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: BlocProvider.of<TabsCubit>(context).selectPage,
        currentIndex: selectedTab,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "Statistics",
            activeIcon: Icon(Icons.bar_chart),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch_outlined),
            label: "Goals",
            activeIcon: Icon(Icons.rocket_launch),
          ),
        ],
      ),
    );
  }
}
