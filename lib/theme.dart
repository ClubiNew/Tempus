import 'package:flutter/material.dart';

class ColorOption {
  final String name;
  final MaterialColor primaryColor;
  final MaterialAccentColor accentColor;

  const ColorOption(
    this.name,
    this.primaryColor,
    this.accentColor,
  );
}

const ColorOption defaultColor =
    ColorOption('Blue', Colors.blue, Colors.blueAccent);

const List<ColorOption> colorOptions = [
  defaultColor,
  ColorOption('Red', Colors.red, Colors.redAccent),
  ColorOption('Green', Colors.lightGreen, Colors.lightGreenAccent),
  ColorOption('Orange', Colors.orange, Colors.orangeAccent),
  ColorOption('Yellow', Colors.yellow, Colors.yellowAccent),
  ColorOption('Pink', Colors.pink, Colors.pinkAccent),
  ColorOption('Indigo', Colors.deepPurple, Colors.deepPurpleAccent),
];

ThemeData lightTheme({ColorOption selectedColor = defaultColor}) {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: selectedColor.primaryColor,
      accentColor: selectedColor.primaryColor,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
  );
}

ThemeData darkTheme({ColorOption selectedColor = defaultColor}) {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: selectedColor.primaryColor,
      accentColor: selectedColor.accentColor,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
  );
}
