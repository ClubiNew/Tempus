import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tempus/models/settings.dart';

import 'sounds.dart';

class _PersistentState {
  int round = 1;
  bool onBreak = false;
  double value = 0;
}

class TimerState extends ChangeNotifier {
  static final _persistentState = _PersistentState();
  PomodoroSettings settings = PomodoroSettings();

  final AudioPlayer audioPlayer;
  double alarmVolume = 100;
  int alarmSound = 0;

  final AnimationController animController;
  final Animation<double> timerAnimation;

  late int round;
  late bool onBreak;

  bool completed = false;
  bool playing = false;
  int sessionNumber = 0;

  String timerText = '00:00';

  TimerState(this.animController, this.timerAnimation, this.audioPlayer) {
    onBreak = _persistentState.onBreak;
    round = _persistentState.round;
    animController.value = _persistentState.value;

    _updateTimerDuration();
    _updateTimerText();

    timerAnimation.addListener(() {
      _persistentState.value = timerAnimation.value;
      _updateTimerText();
      notifyListeners();
    });

    timerAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        endTimer();
      }
    });

    audioPlayer.onPlayerComplete.listen((_) {
      if (completed && settings.loopAlarm) {
        audioPlayer.resume();
      }
    });
  }

  void _updateTimerText({bool notify = false}) {
    Duration remainingDuration =
        animController.duration! * (1 - animController.value);

    String minutes = remainingDuration.inMinutes.toString().padLeft(2, '0');
    String seconds =
        remainingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    final String newText = '$minutes:$seconds';
    if (timerText != newText) {
      timerText = newText;
      if (notify) {
        notifyListeners();
      }
    }
  }

  void _updateTimerDuration() {
    int minutes = settings.workDuration;

    if (onBreak) {
      if (round == settings.rounds) {
        minutes = settings.longBreakDuration;
      } else {
        minutes = settings.shortBreakDuration;
      }
    }

    animController.duration = Duration(minutes: minutes);
  }

  void updateSettings(PomodoroSettings settings) {
    if (this.settings != settings) {
      this.settings = settings;

      if (settings.alarmSound != alarmSound) {
        alarmSound = settings.alarmSound;
        audioPlayer.setSource(
          AssetSource("sounds/${alarmSounds[alarmSound]}.mp3"),
        );
      }

      if (settings.alarmVolume != alarmVolume) {
        alarmVolume = settings.alarmVolume;
        audioPlayer.setVolume(alarmVolume / 100);
      }

      _updateTimerDuration();
      _updateTimerText();
    }
  }

  void nextSession() {
    onBreak = !onBreak;
    _persistentState.onBreak = onBreak;

    if (!onBreak) {
      round = round == settings.rounds ? 1 : round + 1;
      _persistentState.round = round;
    }

    _updateTimerDuration();
    resetTimer();
  }

  void runTimer() {
    playing = true;
    animController.forward();
    notifyListeners();
    // animations will stop updating if the browser tab isn't active,
    // we can use a delayed future as a backup
    int currentSession = ++sessionNumber;
    Duration remainingDuration =
        animController.duration! * (1 - animController.value);
    Future.delayed(
      remainingDuration + const Duration(seconds: 1),
      () => endTimer(fromSession: currentSession),
    );
  }

  void pauseTimer() {
    playing = false;
    notifyListeners();
    animController.stop();
    sessionNumber++;
  }

  void resetTimer() {
    playing = false;
    completed = false;
    animController.stop();
    animController.value = 0;
    audioPlayer.stop();
    sessionNumber++;
  }

  void endTimer({int? fromSession}) {
    fromSession ??= sessionNumber;
    if (!completed && fromSession == sessionNumber) {
      playing = false;
      completed = true;
      notifyListeners();
      audioPlayer.resume();
      sessionNumber++;
    }
  }
}
