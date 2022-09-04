import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/models/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tempus/shared/shared.dart';

import 'timer_state.dart';

class Timer extends StatefulWidget {
  const Timer({Key? key}) : super(key: key);

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AnimationController _animController;
  late final Animation<double> _timerAnimation;
  late final TimerState sourceState;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this);
    _timerAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animController);

    sourceState = TimerState(_animController, _timerAnimation, _audioPlayer);
  }

  @override
  void dispose() {
    sourceState.sessionNumber = -100;
    _audioPlayer.release();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserSettings settings = Provider.of<UserSettings>(context);
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<TimerState>(
      create: (_) => sourceState,
      builder: (context, _) {
        TimerState state = Provider.of<TimerState>(context);
        state.updateSettings(settings.pomodoroSettings);
        return Center(
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
                          state.timerText,
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontSize: 48),
                        ),
                        Text(
                          '${state.onBreak ? "BREAK" : "WORK"} (${state.round}/${settings.pomodoroSettings.rounds})',
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
                        tooltip: "Reset",
                        icon: const Icon(
                          Icons.replay,
                          size: 24.0,
                        ),
                        onPressed: state.resetTimer,
                      ),
                      RoundedIconButton(
                        tooltip: state.playing
                            ? "Pause"
                            : state.completed
                                ? "Stop"
                                : "Start",
                        icon: state.playing
                            ? const Icon(Icons.pause, size: 32.0)
                            : state.completed
                                ? const Icon(Icons.stop, size: 32.0)
                                : const Icon(Icons.play_arrow, size: 32.0),
                        onPressed: () {
                          if (state.playing) {
                            state.pauseTimer();
                          } else if (state.completed) {
                            state.nextSession();
                          } else {
                            state.runTimer();
                          }
                        },
                      ),
                      RoundedIconButton(
                        tooltip: "Skip",
                        icon: const Icon(
                          Icons.skip_next,
                          size: 24.0,
                        ),
                        onPressed: state.nextSession,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
