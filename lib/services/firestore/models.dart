import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Task {
  final String id;
  final String uid;
  final String date;
  String detail;
  int order;
  bool completed;

  Task({
    this.id = '',
    this.uid = '',
    this.date = '',
    this.detail = '',
    this.order = 0,
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable()
class UserSettings {
  bool isDarkTheme;
  int colorTheme;

  UserSettings({
    this.isDarkTheme = false,
    this.colorTheme = 0,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
}
