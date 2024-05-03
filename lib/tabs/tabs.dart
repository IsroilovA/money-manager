import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_new_account/add_account.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/add_transaction/add_transaction_screen.dart';
import 'package:money_manager/goals/goals_screen.dart';
import 'package:money_manager/home/home_screen.dart';
import 'package:money_manager/accounts/accounts_screen.dart';
import 'package:money_manager/services/database_helper.dart';
import 'package:money_manager/statistics/statistics_screen.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  void _addTtansaction() async {
    final newTransaction = await Navigator.of(context).push<TransactionRecord>(
      MaterialPageRoute(
        builder: (ctx) => const AddNewTransaction(),
      ),
    );
    if (newTransaction == null) {
      return;
    }
    setState(() {
      DatabaseHelper.addTransationRecord(newTransaction);
      DatabaseHelper.updateAccountBalance(
          newTransaction, newTransaction.accountId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabsCubit(),
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          if (state is TabsInitial) {
            BlocProvider.of<TabsCubit>(context).loadAccounts();
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is TabsNoAccounts) {
            return const AddNewAccount();
          } else if (state is TabsLoaded) {
            return _buildTabsScreen(context, state.account, 0);
          } else if (state is TabsError) {
            return Center(
              child: Text("Error: ${state.message}"),
            );
          } else if (state is TabsPageChanged) {
            return _buildTabsScreen(context, state.account, state.pageIndex);
          } else {
            return const Center(child: Text("Something is wrond"));
          }
        },
      ),
    );
  }

  Widget _buildTabsScreen(
      BuildContext context, Account account, int pageIndex) {
    
    switch(pageIndex){
      
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("pageTitle"),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: pageIndex,
        children: [
          HomeScreen(account: account),
          const StatisticsScreen(),
          const GoalsScreen(),
          const AccountsScreen()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTtansaction,
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
        onTap: context.read<TabsCubit>().selectPage,
        currentIndex: pageIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black,
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
