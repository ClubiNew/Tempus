import 'package:tempus/screens/screens.dart';

var appRoutes = {
  '/': (context) => HomeScreen(),
  '/goals': (context) => const GoalsScreen(),
  '/journal': (context) => const JournalScreen(),
  '/pomodoro': (context) => const PomodoroScreen(),
  '/tasks': (context) => const TasksScreen(),
};
