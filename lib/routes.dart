import 'package:tempus/screens/screens.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/goals': (context) => const GoalsScreen(),
  '/notes': (context) => const NotesScreen(),
  '/pomodoro': (context) => const PomodoroScreen(),
  '/tasks': (context) => const TasksScreen(),
};
