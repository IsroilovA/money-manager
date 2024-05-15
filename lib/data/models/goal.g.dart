// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) => Goal(
      name: json['name'] as String,
      currentBalance: (json['currentBalance'] as num).toDouble(),
      goalBalance: (json['goalBalance'] as num).toDouble(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
      'name': instance.name,
      'currentBalance': instance.currentBalance,
      'goalBalance': instance.goalBalance,
      'id': instance.id,
    };
