import 'package:json_annotation/json_annotation.dart';
import 'serializers.dart';
part 'settings.g.dart';

@JsonSerializable()
class ThemeSettings extends SerializableDocument {
  bool darkMode;
  int color;

  ThemeSettings({
    this.darkMode = false,
    this.color = 0,
  });

  @override
  Map<String, dynamic> toJson() => _$ThemeSettingsToJson(this);
  factory ThemeSettings.fromJson(Map<String, dynamic> json) =>
      _$ThemeSettingsFromJson(json);
}

@JsonSerializable()
class PomodoroSettings extends SerializableDocument {
  int workDuration;
  int shortBreakDuration;
  int longBreakDuration;
  int rounds;

  int alarmSound;
  double alarmVolume;
  bool loopAlarm;

  PomodoroSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 30,
    this.rounds = 4,
    this.alarmSound = 0,
    this.alarmVolume = 100,
    this.loopAlarm = true,
  });

  @override
  Map<String, dynamic> toJson() => _$PomodoroSettingsToJson(this);
  factory PomodoroSettings.fromJson(Map<String, dynamic> json) =>
      _$PomodoroSettingsFromJson(json);
}

@JsonSerializable()
class UserSettings {
  @JsonKey(toJson: serializeDocument)
  late final ThemeSettings themeSettings;
  @JsonKey(toJson: serializeDocument)
  late final PomodoroSettings pomodoroSettings;
  String stickyNote;

  UserSettings({
    ThemeSettings? themeSettings,
    PomodoroSettings? pomodoroSettings,
    this.stickyNote = "",
  }) {
    this.themeSettings = themeSettings ?? ThemeSettings();
    this.pomodoroSettings = pomodoroSettings ?? PomodoroSettings();
  }

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
