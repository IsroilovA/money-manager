import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
}
