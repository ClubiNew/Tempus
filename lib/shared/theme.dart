import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Roboto',
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Roboto',
);

class ThemeState extends ChangeNotifier {
  ThemeState(this.activeTheme);
  ThemeData activeTheme;

  void setTheme(ThemeData theme) {
    activeTheme = theme;
    notifyListeners();
  }
}
