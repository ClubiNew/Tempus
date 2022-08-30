import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  const NavBar({required this.currentIndex, Key? key}) : super(key: key);
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBarTheme(
      data: BottomNavigationBarThemeData(
        unselectedItemColor: colorScheme.inverseSurface,
        selectedItemColor: Colors.lightBlue,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.listCheck),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendarCheck),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.pen),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clock),
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
