import 'package:flutter/material.dart';
import 'package:money_manager/widgets/balance_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [BalanceCard()]);
  }
}
