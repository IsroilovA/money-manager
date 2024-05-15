import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

const uuid = Uuid();

@JsonSerializable()
class Goal {
  final String name;
  final double currentBalance;
  final double goalBalance;
  final String id;
  Goal({
    required this.name,
    required this.currentBalance,
    required this.goalBalance,
    id,
  }) : id = id ?? uuid.v4();

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  Map<String, dynamic> toJson() => _$GoalToJson(this);
}
