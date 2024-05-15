import 'package:flutter/material.dart';
import 'package:money_manager/data/models/goal.dart';

class GoalItem extends StatelessWidget {
  const GoalItem({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [Text(goal.name)],
      ),
    );
  }
}
