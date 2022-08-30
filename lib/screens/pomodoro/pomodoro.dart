import 'package:flutter/material.dart';

import '../../shared/nav_bar.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Pomodoro",
          textScaleFactor: 2,
        ),
      ),
      bottomNavigationBar: Hero(
        tag: 'navbar',
        child: NavBar(
          currentIndex: 4,
        ),
      ),
    );
  }
}
