import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/models/settings.dart';
import 'package:tempus/services/settings.dart';
import 'package:tempus/shared/cards.dart';
import 'package:tempus/shared/app_bar.dart';

import 'sounds.dart';

class PomodoroSettingsScreen extends StatelessWidget {
  const PomodoroSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        allowNavigation: true,
      ),
      body: CardList(
        children: [
          _SoundSettings(),
          _TimerSettings(),
        ],
      ),
    );
  }
}

class _SoundSettings extends StatefulWidget {
  const _SoundSettings({Key? key}) : super(key: key);

  @override
  State<_SoundSettings> createState() => _SoundSettingsState();
}

class _SoundSettingsState extends State<_SoundSettings> {
  final SettingsService settingsService = SettingsService();
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
    final UserSettings userSettings = Provider.of<UserSettings>(context);
    final PomodoroSettings settings = userSettings.pomodoroSettings;

    return SettingsCard(
      title: 'Sounds',
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
                settingsService.saveSettings(userSettings);
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
              settingsService.saveSettings(userSettings);
            },
          ),
        ),
        Setting(
          title: "Loop Alarm",
          child: Switch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: settings.loopAlarm,
            onChanged: (bool value) {
              settings.loopAlarm = value;
              settingsService.saveSettings(userSettings);
            },
          ),
        ),
      ],
    );
  }
}

class _TimerSettings extends StatefulWidget {
  const _TimerSettings({Key? key}) : super(key: key);

  @override
  State<_TimerSettings> createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<_TimerSettings> {
  final SettingsService settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    final UserSettings userSettings = Provider.of<UserSettings>(context);
    final PomodoroSettings settings = userSettings.pomodoroSettings;

    return SettingsCard(
      title: "Timer Duration",
      settings: [
        Setting(
          title: 'Work',
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
              settingsService.saveSettings(userSettings);
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
              setState(() => settings.shortBreakDuration = newValue.round());
            },
            onChangeEnd: (double newValue) {
              settings.shortBreakDuration = newValue.round();
              settingsService.saveSettings(userSettings);
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
              setState(() => settings.longBreakDuration = newValue.round());
            },
            onChangeEnd: (double newValue) {
              settings.longBreakDuration = newValue.round();
              settingsService.saveSettings(userSettings);
            },
          ),
        ),
        Setting(
          title: 'Rounds',
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
              SettingsService().saveSettings(userSettings);
            },
          ),
        ),
      ],
    );
  }
}
