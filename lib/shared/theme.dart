import 'package:flutter/material.dart';

class ColorOption {
  ColorOption(this.name, this.primaryColor, this.accentColor);
  final String name;
  final MaterialColor primaryColor;
  final MaterialAccentColor accentColor;
}

List<ColorOption> colorOptions = [
  ColorOption("Blue", Colors.blue, Colors.blueAccent),
  ColorOption("Red", Colors.red, Colors.redAccent),
  ColorOption("Green", Colors.lightGreen, Colors.greenAccent),
  ColorOption("Orange", Colors.orange, Colors.orangeAccent),
  ColorOption("Purple", Colors.deepPurple, Colors.deepPurpleAccent),
];

class ThemeState extends ChangeNotifier {
  ThemeState(this.isDarkTheme, this.colorTheme);
  bool isDarkTheme;
  int colorTheme;

  ThemeData get activeTheme {
    ColorOption selectedColor = colorOptions[colorTheme];
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: selectedColor.primaryColor,
        accentColor: isDarkTheme
            ? selectedColor.accentColor
            : selectedColor.primaryColor,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      fontFamily: 'Roboto',
    );
  }

  void setDarkMode(bool isDarkTheme) {
    this.isDarkTheme = isDarkTheme;
    notifyListeners();
  }

  void setColor(int colorTheme) {
    this.colorTheme = colorTheme;
    notifyListeners();
  }
}
