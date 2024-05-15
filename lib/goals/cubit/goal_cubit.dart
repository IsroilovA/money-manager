import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/add_goal/add_goal_screen.dart';
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
      await DatabaseHelper.addSavedAmount(goal, addedBalance);
      final updatedGoal = await DatabaseHelper.getGoalById(goal.id);
      emit(GoalBalanceEdited(updatedGoal));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  void addGoal(BuildContext context) async {
    final newGoal = await Navigator.of(context).push<Goal>(
      MaterialPageRoute(
        builder: (ctx) => const AddGoalScreen(),
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
