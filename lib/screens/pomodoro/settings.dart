import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/pomodoro/sounds.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:tempus/services/firestore/settings.dart';
import 'package:tempus/shared/cards.dart';

class PomodoroSettingsScreen extends StatefulWidget {
  const PomodoroSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroSettingsScreen> createState() => _PomodoroSettingsScreenState();
}

class _PomodoroSettingsScreenState extends State<PomodoroSettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final AudioPlayer player = AudioPlayer();

  void previewSound(int alarmSoundIdx, double volume) {
    player.play(
      AssetSource("sounds/${alarmSounds[alarmSoundIdx]}.mp3"),
      volume: volume / 100,
    );
  }

  @override
  void dispose() {
    player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PomodoroSettings settings = Provider.of<PomodoroSettings>(context);
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: false,
      ),
      body: CardList(
        children: [
          SettingsCard(
            title: "Sounds",
            settings: [
              Setting(
                title: "Alarm Sound",
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: DropdownButton<int>(
                    value: settings.alarmSound,
                    elevation: 4,
                    isExpanded: true,
                    onChanged: (int? alarmSoundIdx) {
                      previewSound(alarmSoundIdx!, settings.alarmVolume);
                      settings.alarmSound = alarmSoundIdx;
                      _settingsService.updatePomodoroSettings(settings);
                    },
                    items: alarmSounds
                        .asMap()
                        .entries
                        .map(
                          (option) => DropdownMenuItem<int>(
                            value: option.key,
                            child: Text(option.value),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Setting(
                title: "Alarm Volume",
                child: Slider(
                  value: settings.alarmVolume,
                  divisions: 10,
                  max: 100,
                  label: '${settings.alarmVolume.round()}%',
                  onChanged: (double newValue) {
                    setState(() => settings.alarmVolume = newValue);
                  },
                  onChangeEnd: (double newValue) {
                    settings.alarmVolume = newValue;
                    _settingsService.updatePomodoroSettings(settings);
                  },
                ),
              ),
              Setting(
                title: "Loop Alarm",
                child: Switch(
                  activeColor: theme.colorScheme.primary,
                  value: settings.loopAlarm,
                  onChanged: (bool value) {
                    settings.loopAlarm = value;
                    SettingsService().updatePomodoroSettings(settings);
                  },
                ),
              ),
            ],
          ),
          SettingsCard(
            title: "Timer Duration",
            settings: [
              Setting(
                title: "Work",
                child: Slider(
                  value: settings.workDuration.toDouble(),
                  divisions: 11,
                  min: 5,
                  max: 60,
                  label: '${settings.workDuration}m',
                  onChanged: (double newValue) {
                    setState(() => settings.workDuration = newValue.round());
                  },
                  onChangeEnd: (double newValue) {
                    settings.workDuration = newValue.round();
                    _settingsService.updatePomodoroSettings(settings);
                  },
                ),
              ),
              Setting(
                title: "Short Break",
                child: Slider(
                  value: settings.shortBreakDuration.toDouble(),
                  divisions: 29,
                  min: 1,
                  max: 30,
                  label: '${settings.shortBreakDuration}m',
                  onChanged: (double newValue) {
                    setState(
                        () => settings.shortBreakDuration = newValue.round());
                  },
                  onChangeEnd: (double newValue) {
                    settings.shortBreakDuration = newValue.round();
                    _settingsService.updatePomodoroSettings(settings);
                  },
                ),
              ),
              Setting(
                title: "Long Break",
                child: Slider(
                  value: settings.longBreakDuration.toDouble(),
                  divisions: 59,
                  min: 1,
                  max: 60,
                  label: '${settings.longBreakDuration}m',
                  onChanged: (double newValue) {
                    setState(
                        () => settings.longBreakDuration = newValue.round());
                  },
                  onChangeEnd: (double newValue) {
                    settings.longBreakDuration = newValue.round();
                    _settingsService.updatePomodoroSettings(settings);
                  },
                ),
              ),
              Setting(
                title: "Rounds",
                child: Slider(
                  value: settings.rounds.toDouble(),
                  divisions: 8,
                  min: 2,
                  max: 10,
                  label: '${settings.rounds}',
                  onChanged: (double newValue) {
                    setState(() => settings.rounds = newValue.round());
                  },
                  onChangeEnd: (double newValue) {
                    settings.rounds = newValue.round();
                    _settingsService.updatePomodoroSettings(settings);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
