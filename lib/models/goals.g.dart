// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) => Goal(
      json['objective'] as String,
      (json['progress'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
      'objective': instance.objective,
      'progress': instance.progress,
      'createdAt': instance.createdAt.toIso8601String(),
    };
