import 'package:flutter/material.dart';
import 'package:money_manager/data/dummy_data.dart';
import 'package:money_manager/models/account.dart';
import 'package:money_manager/models/transaction_record.dart';
import 'package:money_manager/screens/add_transaction_screen.dart';
import 'package:money_manager/screens/goals_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/screens/accounts_screen.dart';
import 'package:money_manager/screens/statistics_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Account account = cash;

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
      cash.records.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = switch (_selectedPageIndex) {
      0 => HomeScreen(account: cash),
      1 => const StatisticsScreen(),
      2 => const GoalsScreen(),
      3 => const AccountsScreen(),
      _ => throw UnimplementedError(),
    };
    var pageTitle =
        activePage.toString().substring(0, activePage.toString().length - 6);

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
      ),
      body: activePage,
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
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
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
              icon: Icon(Icons.person_outline),
              label: "Accounts",
              activeIcon: Icon(Icons.account_balance_outlined))
        ],
      ),
    );
  }
}
