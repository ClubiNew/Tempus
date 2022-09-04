import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBarTheme(
      data: BottomNavigationBarThemeData(
        unselectedItemColor: colorScheme.inverseSurface,
        selectedItemColor: colorScheme.primary,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),
        ],
        onTap: (int idx) {
          switch (idx) {
            case 0:
              Navigator.pushReplacementNamed(context, '/tasks');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/goals');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/journal');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/pomodoro');
              break;
          }
        },
      ),
    );
  }
}
