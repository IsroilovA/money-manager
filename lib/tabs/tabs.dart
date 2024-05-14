import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_new_account/add_account.dart';
import 'package:money_manager/goals/goals_screen.dart';
import 'package:money_manager/home/home_screen.dart';
import 'package:money_manager/accounts/accounts_list_screen.dart';
import 'package:money_manager/statistics/statistics_screen.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

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
      3 => "Accounts",
      _ => throw UnimplementedError(),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
        actions: [
          if (pageTitle == "Accounts")
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AddNewAccount()),
                  );
                },
                icon: const Icon(Icons.add))
        ],
      ),
      body: BlocConsumer<TabsCubit, TabsState>(
        listener: (context, state) {
          if (state is TabsTransactionDeleted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Transaction deleted"),
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is TabsTransactionAdded) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Transaction added"),
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is TabsNoAccounts) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AddNewAccount(),
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
            return const AddNewAccount();
          } else if (state is TabsLoaded) {
            return IndexedStack(
              index: selectedTab,
              children: [
                HomeScreen(
                  accounts: state.accounts,
                ),
                const StatisticsScreen(),
                const GoalsScreen(),
                AccountsScreen(accounts: state.accounts)
              ],
            );
          } else if (state is TabsError) {
            return Center(
              child: Text("Error: ${state.message}"),
            );
          } else {
            return const Center(child: Text("Something is wrond"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TabsCubit>().addTtansaction(context, selectedTab);
        },
        shape: const CircleBorder(),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        onTap: BlocProvider.of<TabsCubit>(context).selectPage,
        currentIndex: selectedTab,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              activeIcon: Icon(Icons.home)),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: "Statistics",
              activeIcon: Icon(Icons.bar_chart)),
          BottomNavigationBarItem(
              icon: Icon(Icons.rocket_launch_outlined),
              label: "Goals",
              activeIcon: Icon(Icons.rocket_launch)),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_outlined),
              label: "Accounts",
              activeIcon: Icon(Icons.account_balance))
        ],
      ),
    );
  }
}
