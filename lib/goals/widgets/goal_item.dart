import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/goals/cubit/goal_cubit.dart';
import 'package:money_manager/goals/widgets/goal_details.dart';
import 'package:money_manager/services/helper_fucntions.dart';

class GoalItem extends StatelessWidget {
  const GoalItem({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => GoalCubit(),
                child: GoalDetails(goal: goal),
              ),
            ),
          );
          BlocProvider.of<GoalCubit>(context).loadGoals();
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
                  Text(currencyFormatter.format(goal.currentBalance)),
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
