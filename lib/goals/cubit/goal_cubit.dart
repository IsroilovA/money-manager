import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/add_goal/add_edit_goal_screen.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/services/database_helper.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalCubit() : super(GoalInitial());

  // Load all goals from the database and emit the appropriate state
  void loadGoals() async {
    try {
      final goals = await DatabaseHelper.getAllGoals();
      if (goals != null && goals.isNotEmpty) {
        emit(GoalsLoaded(goals));
      } else {
        emit(NoGoals());
      }
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  // Add a specified amount to a goal and emit the updated goal state
  void addAmount(Goal goal, double addedBalance) async {
    try {
      await DatabaseHelper.addGoalSavedAmount(goal, addedBalance);
      final updatedGoal = await DatabaseHelper.getGoalById(goal.id);
      emit(GoalEdited(updatedGoal));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  // Edit a goal by navigating to the AddEditGoalScreen and emitting the updated goal state
  void editGoal(BuildContext context, String goalId) async {
    final goal = await DatabaseHelper.getGoalById(goalId);
    final editedGoal = context.mounted
        ? await Navigator.of(context).push<Goal>(
            MaterialPageRoute(
              builder: (ctx) => AddEditGoalScreen(goal: goal),
            ),
          )
        : null;
    if (editedGoal == null) {
      return;
    }
    try {
      await DatabaseHelper.editGoal(editedGoal);
      final updatedGoal = await DatabaseHelper.getGoalById(goalId);
      emit(GoalEdited(updatedGoal));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  // Delete a goal and emit an appropriate state
  void deleteGoal(Goal goal) async {
    try {
      await DatabaseHelper.deleteGoal(goal);
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  // Add a new goal by navigating to the AddEditGoalScreen and emitting the initial state
  void addGoal(BuildContext context) async {
    final newGoal = await Navigator.of(context).push<Goal>(
      MaterialPageRoute(
        builder: (ctx) => const AddEditGoalScreen(),
      ),
    );
    if (newGoal == null) {
      return;
    }
    try {
      await DatabaseHelper.addGoal(newGoal);
      emit(GoalInitial());
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
