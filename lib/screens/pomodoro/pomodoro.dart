import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/pomodoro/progress_circle.dart';
import 'package:tempus/screens/pomodoro/settings.dart';
import 'package:tempus/screens/pomodoro/sounds.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:audioplayers/audioplayers.dart';
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
  double _alarmVolume = 100;
  int _alarmSound = 0;

  late Animation<double> _timerAnimation;
  late AnimationController _controller;

  PomodoroState previousState = PomodoroState.instance;
  bool initialized = false;

  late int round;
  String timerText = '00:00';
  bool onBreak = false;
  bool completed = false;
  bool playing = false;
  int playCount = 0;

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
        complete();
      }
    });

    _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
    _audioPlayer.onPlayerComplete.listen((_) {
      if (completed && _settings.loopAlarm) {
        _audioPlayer.resume();
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

  void complete({int? playInstance}) {
    if (!completed && (playInstance == null || playInstance == playCount)) {
      setState(() {
        playing = false;
        completed = true;
      });
      _audioPlayer.resume();
      playCount++;
    }
  }

  void nextSession() {
    setState(() {
      onBreak = !onBreak;
      previousState.onBreak = onBreak;

      if (!onBreak) {
        round = round == _settings.rounds ? 1 : round + 1;
        previousState.round = round;
      }
    });

    reset();
  }

  void reset() {
    _audioPlayer.stop();
    _controller.duration = Duration(minutes: getTotalMinutes());
    _controller.value = 0;
    setState(() {
      playing = false;
      completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    _settings = Provider.of<PomodoroSettings>(context);

    if (_settings.alarmSound != _alarmSound) {
      _alarmSound = _settings.alarmSound;
      _audioPlayer.setSource(
        AssetSource("sounds/${alarmSounds[_alarmSound]}.mp3"),
      );
    }

    if (_settings.alarmVolume != _alarmVolume) {
      _alarmVolume = _settings.alarmVolume;
      _audioPlayer.setVolume(_alarmVolume / 100);
    }

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
                      onPressed: reset,
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
                          playCount++;
                        } else if (completed) {
                          nextSession();
                        } else {
                          setState(() => playing = true);
                          _controller.forward();
                          // animations will stop updating if the browser tab
                          // isn't active, so we need a backup
                          int playInstance = ++playCount;
                          Duration remainingDuration =
                              _controller.duration! * (1 - _controller.value);
                          Future.delayed(
                            remainingDuration + const Duration(seconds: 1),
                            () => complete(playInstance: playInstance),
                          );
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
