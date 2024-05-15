part of 'goal_cubit.dart';

@immutable
sealed class GoalState {}

final class GoalInitial extends GoalState {}

final class GoalLoading extends GoalState {}

final class NoGoals extends GoalState {}

final class GoalsLoaded extends GoalState {
  final List<Goal> goals;
  GoalsLoaded(this.goals);
}

final class GoalBalanceEdited extends GoalState {
  final Goal updatedGoal;
  GoalBalanceEdited(this.updatedGoal);
}

final class GoalError extends GoalState {
  final String message;
  GoalError(this.message);
}
