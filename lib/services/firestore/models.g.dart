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
      isDarkTheme: json['isDarkTheme'] as bool? ?? false,
      colorTheme: json['colorTheme'] as int? ?? 0,
      stickyNote: json['stickyNote'] as String? ?? '',
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'isDarkTheme': instance.isDarkTheme,
      'colorTheme': instance.colorTheme,
      'stickyNote': instance.stickyNote,
    };
