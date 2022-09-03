// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      date: json['date'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'date': instance.date,
      'detail': instance.detail,
      'order': instance.order,
      'completed': instance.completed,
    };

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      darkMode: json['darkMode'] as bool? ?? false,
      colorTheme: json['colorTheme'] as int? ?? 0,
      stickyNote: json['stickyNote'] as String? ?? '',
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'darkMode': instance.darkMode,
      'colorTheme': instance.colorTheme,
      'stickyNote': instance.stickyNote,
    };

PomodoroSettings _$PomodoroSettingsFromJson(Map<String, dynamic> json) =>
    PomodoroSettings(
      workDuration: json['workDuration'] as int? ?? 25,
      shortBreakDuration: json['shortBreakDuration'] as int? ?? 5,
      longBreakDuration: json['longBreakDuration'] as int? ?? 30,
      rounds: json['rounds'] as int? ?? 4,
      alarmSound: json['alarmSound'] as int? ?? 0,
      alarmVolume: (json['alarmVolume'] as num?)?.toDouble() ?? 100,
      loopAlarm: json['loopAlarm'] as bool? ?? true,
      saved: json['saved'] as bool? ?? true,
    );

Map<String, dynamic> _$PomodoroSettingsToJson(PomodoroSettings instance) =>
    <String, dynamic>{
      'workDuration': instance.workDuration,
      'shortBreakDuration': instance.shortBreakDuration,
      'longBreakDuration': instance.longBreakDuration,
      'rounds': instance.rounds,
      'alarmSound': instance.alarmSound,
      'alarmVolume': instance.alarmVolume,
      'loopAlarm': instance.loopAlarm,
      'saved': instance.saved,
    };
