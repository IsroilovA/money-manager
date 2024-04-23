import 'package:flutter/material.dart';
import 'package:money_manager/screens/goals.dart';
import 'package:money_manager/screens/home.dart';
import 'package:money_manager/screens/profile.dart';
import 'package:money_manager/screens/statistics.dart';

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

  @override
  Widget build(BuildContext context) {
    Widget activePage = switch (_selectedPageIndex) {
      0 => const HomeScreen(),
      1 => const StatisticsScreen(),
      2 => const GoalsScreen(),
      3 => const ProfileScreen(),
      _ => throw UnimplementedError(),
    };
    var pageTitle = "Home";
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              activeIcon: Icon(Icons.home)),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: "Stats",
              activeIcon: Icon(Icons.bar_chart)),
          BottomNavigationBarItem(
              icon: Icon(Icons.rocket_launch_outlined),
              label: "Goals",
              activeIcon: Icon(Icons.rocket_launch)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
              activeIcon: Icon(Icons.person))
        ],
      ),
    );
  }
}
