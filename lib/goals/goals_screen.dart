import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/goals/cubit/goal_cubit.dart';
import 'package:money_manager/goals/widgets/goal_item.dart';
import 'package:money_manager/services/locator.dart';
import 'package:money_manager/services/money_manager_repository.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocProvider(
        create: (context) => GoalCubit(
            moneyManagerRepository: locator<MoneyManagerRepository>()),
        child: BlocBuilder<GoalCubit, GoalState>(
          buildWhen: (previous, current) {
            return true;
          },
          builder: (context, state) {
            if (state is GoalsLoaded) {
              // Display the list of goals
              return ListView.builder(
                //add one tot he goals count
                itemCount: state.goals.length + 1,
                itemBuilder: (context, index) {
                  // If the index is within the goals list, show a GoalItem
                  // Otherwise, show an add button
                  return (index != state.goals.length)
                      ? GoalItem(goal: state.goals[index])
                      : IconButton(
                          onPressed: () {
                            context.read<GoalCubit>().addGoal(context);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        );
                },
              );
            } else if (state is NoGoals) {
              // Display message and add button when there are no goals
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No goals yet",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<GoalCubit>().addGoal(context);
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is GoalInitial) {
              // Load goals when the initial state is reached
              BlocProvider.of<GoalCubit>(context).loadGoals();
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is GoalLoading) {
              // Show loading indicator while loading goals
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is GoalError) {
              // Display error message if there is an error
              return Center(
                child: Text("Error: ${state.message}"),
              );
            } else {
              // Fallback for any unexpected state
              return const Center(
                child: Text("Something went wrong"),
              );
            }
          },
        ),
      ),
    );
  }
}
