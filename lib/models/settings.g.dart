// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeSettings _$ThemeSettingsFromJson(Map<String, dynamic> json) =>
    ThemeSettings(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      color: json['color'] as int? ?? 0,
    );

Map<String, dynamic> _$ThemeSettingsToJson(ThemeSettings instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode],
      'color': instance.color,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
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
    };

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      themeSettings: json['themeSettings'] == null
          ? null
          : ThemeSettings.fromJson(
              json['themeSettings'] as Map<String, dynamic>),
      pomodoroSettings: json['pomodoroSettings'] == null
          ? null
          : PomodoroSettings.fromJson(
              json['pomodoroSettings'] as Map<String, dynamic>),
      stickyNote: json['stickyNote'] as String? ?? "",
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'themeSettings': serializeDocument(instance.themeSettings),
      'pomodoroSettings': serializeDocument(instance.pomodoroSettings),
      'stickyNote': instance.stickyNote,
    };
