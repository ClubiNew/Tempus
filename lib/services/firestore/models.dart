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
  bool darkMode;
  int colorTheme;
  String stickyNote;

  UserSettings({
    this.darkMode = false,
    this.colorTheme = 0,
    this.stickyNote = '',
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
}

@JsonSerializable()
class PomodoroSettings {
  int workDuration;
  int shortBreakDuration;
  int longBreakDuration;
  int rounds;

  int alarmSound;
  double alarmVolume;

  bool saved;

  PomodoroSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 30,
    this.rounds = 4,
    this.alarmSound = 0,
    this.alarmVolume = 100,
    this.saved = true,
  });

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) =>
      _$PomodoroSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$PomodoroSettingsToJson(this);
}
