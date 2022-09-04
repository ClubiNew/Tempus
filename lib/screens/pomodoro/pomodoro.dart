import 'package:flutter/material.dart';
import 'package:tempus/shared/app_bar.dart';
import 'package:tempus/shared/nav_bar.dart';

import 'timer.dart';
import 'settings.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pomodoro',
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PomodoroSettingsScreen(),
              ),
            ),
          )
        ],
      ),
      body: const Timer(),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(
          currentIndex: 4,
        ),
      ),
    );
  }
}
