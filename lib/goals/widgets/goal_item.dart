import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/goals/cubit/goal_cubit.dart';
import 'package:money_manager/goals/widgets/goal_details.dart';
import 'package:money_manager/services/helper_functions.dart';

/// A widget that displays a goal item with its details. When tapped, it navigates to the goal details screen.
class GoalItem extends StatelessWidget {
  const GoalItem({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          // Navigate to the goal details screen
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => GoalCubit(),
                child: GoalDetails(goal: goal),
              ),
            ),
          );
          if (context.mounted) {
            // Reload goals after returning from the goal details screen
            BlocProvider.of<GoalCubit>(context).loadGoals();
          }
        },
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
        horizontalTitleGap: 0,
        minVerticalPadding: 15,
        contentPadding: const EdgeInsets.only(right: 10, left: 16),
        title: Text(goal.name.capitalize()),
        subtitle: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display current balance of the goal
                  Text(currencyFormatter.format(goal.currentBalance)),
                  // Display percentage progress towards the goal
                  Text(
                      "${(goal.currentBalance / goal.goalBalance * 100).toStringAsFixed(1)}%"),
                ],
              ),
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
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
