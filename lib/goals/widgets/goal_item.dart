import 'package:flutter/material.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/data/models/transaction_record.dart';

class GoalItem extends StatelessWidget {
  const GoalItem({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(goal.name),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currencyFormatter.format(goal.currentBalance),
                ),
                Text(
                  "${(goal.currentBalance / goal.goalBalance) * 100}%",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                value: goal.currentBalance / goal.goalBalance,
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
