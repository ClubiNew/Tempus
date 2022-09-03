import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/pomodoro/progress_circle.dart';
import 'package:tempus/screens/pomodoro/settings.dart';
import 'package:tempus/screens/pomodoro/sounds.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:tempus/shared/nav_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tempus/shared/rounded_icon_button.dart';
import 'package:tempus/shared/shared.dart';

import 'pomodoro_state.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PomodoroSettings _settings = PomodoroSettings();

  late Animation<double> _timerAnimation;
  late AnimationController _controller;

  PomodoroState previousState = PomodoroState.instance;
  bool initialized = false;

  late int round;
  bool onBreak = false;
  bool playing = false;
  bool completed = false;
  String timerText = '00:00';

  @override
  void initState() {
    super.initState();

    round = previousState.round;
    onBreak = previousState.onBreak;

    _controller = AnimationController(
      vsync: this,
      value: previousState.progress,
    );

    _timerAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _timerAnimation.addListener(() {
      setState(() => timerText = getTimerText());
      previousState.progress = _timerAnimation.value;
    });

    _timerAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _audioPlayer.play(
          AssetSource("sounds/${alarmSounds[_settings.alarmSound]}.mp3"),
          volume: _settings.alarmVolume / 100,
        );

        setState(() {
          playing = false;
          completed = true;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (completed) {
        _audioPlayer.play(
          AssetSource("sounds/${alarmSounds[_settings.alarmSound]}.mp3"),
          volume: _settings.alarmVolume / 100,
        );
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _controller.dispose();
    super.dispose();
  }

  int getTotalMinutes() {
    if (!onBreak) {
      return _settings.workDuration;
    } else if (round == _settings.rounds) {
      return _settings.longBreakDuration;
    } else {
      return _settings.shortBreakDuration;
    }
  }

  String getTimerText() {
    if (_controller.duration == null) {
      return '00:00';
    }

    Duration remainingDuration =
        _controller.duration! * (1 - _controller.value);

    String minutes = remainingDuration.inMinutes.toString().padLeft(2, '0');
    String seconds =
        remainingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void nextSession() {
    setState(() {
      playing = false;
      completed = false;

      onBreak = !onBreak;
      previousState.onBreak = onBreak;

      if (!onBreak) {
        round = round == _settings.rounds ? 1 : round + 1;
        previousState.round = round;
      }
    });

    _controller.duration = Duration(minutes: getTotalMinutes());
    _controller.value = 0;
    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    _settings = Provider.of<PomodoroSettings>(context);

    if (!initialized && _settings.saved) {
      _controller.duration = Duration(minutes: getTotalMinutes());
      timerText = getTimerText();
      initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: "Settings",
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PomodoroSettingsScreen(),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ProgressCircle(
                  animation: _timerAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timerText,
                        style:
                            theme.textTheme.titleLarge!.copyWith(fontSize: 48),
                      ),
                      Text(
                        "${onBreak ? 'BREAK' : 'WORK'} ($round/${_settings.rounds})",
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedIconButton(
                      icon: const Icon(
                        Icons.replay,
                        size: 24.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.duration =
                              Duration(minutes: getTotalMinutes());
                          _controller.value = 0;
                          playing = false;
                          completed = false;
                        });
                      },
                    ),
                    RoundedIconButton(
                      icon: playing
                          ? const Icon(Icons.pause, size: 32.0)
                          : completed
                              ? const Icon(Icons.stop, size: 32.0)
                              : const Icon(Icons.play_arrow, size: 32.0),
                      onPressed: () {
                        if (playing) {
                          _controller.stop(canceled: false);
                          setState(() => playing = false);
                        } else if (completed) {
                          nextSession();
                        } else {
                          setState(() => playing = true);
                          _controller.forward();
                        }
                      },
                    ),
                    RoundedIconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        size: 24.0,
                      ),
                      onPressed: nextSession,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(
          currentIndex: 4,
        ),
      ),
    );
  }
}
