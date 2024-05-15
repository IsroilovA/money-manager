import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/goals/cubit/goal_cubit.dart';
import 'package:money_manager/goals/widgets/goal_item.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocProvider(
        create: (context) => GoalCubit(),
        child: BlocBuilder<GoalCubit, GoalState>(
          builder: (context, state) {
            if (state is GoalsLoaded) {
              return GridView.builder(
                itemCount: state.goals.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GoalItem(goal: state.goals[index]);
                },
              );
            } else if (state is NoGoals) {
              return Center(
                child: Text(
                  "No goals yet",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              );
            } else if (state is GoalInitial) {
              BlocProvider.of<GoalCubit>(context).loadGoals();
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is GoalLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is GoalError) {
              return Center(
                child: Text("Error: ${state.message}"),
              );
            } else {
              return const Center(
                child: Text("something went wrong"),
              );
            }
          },
        ),
      ),
    );
  }
}
