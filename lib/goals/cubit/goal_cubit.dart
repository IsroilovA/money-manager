import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/add_goal/add_edit_goal_screen.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/services/database_helper.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalCubit() : super(GoalInitial());

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

  void addAmount(Goal goal, double addedBalance) async {
    try {
      await DatabaseHelper.addGoalSavedAmount(goal, addedBalance);
      final updatedGoal = await DatabaseHelper.getGoalById(goal.id);
      emit(GoalEdited(updatedGoal));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  void editGoal(BuildContext context, String goalId) async {
    final goal = await DatabaseHelper.getGoalById(goalId);
    final editedGoal = await Navigator.of(context).push<Goal>(
      MaterialPageRoute(
        builder: (ctx) => AddEditGoalScreen(goal: goal),
      ),
    );
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

  void deleteGoal(Goal goal) async {
    try {
      await DatabaseHelper.deleteGoal(goal);
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

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
