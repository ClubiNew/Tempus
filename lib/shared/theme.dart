import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html';

// https://github.com/flutter/flutter/issues/93140
String? fontFamily = kIsWeb && window.navigator.userAgent.contains('OS 15_')
    ? '-apple-system'
    : null;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: fontFamily,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: fontFamily,
);

class ThemeState extends ChangeNotifier {
  ThemeState(this.activeTheme);
  ThemeData activeTheme;

  void setTheme(ThemeData theme) {
    activeTheme = theme;
    notifyListeners();
  }
}
