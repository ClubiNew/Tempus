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
  ColorOption("Yellow", Colors.yellow, Colors.yellowAccent),
  ColorOption("Pink", Colors.pink, Colors.pinkAccent),
  ColorOption("Indigo", Colors.deepPurple, Colors.deepPurpleAccent),
];
