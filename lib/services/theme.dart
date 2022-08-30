import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// fontFamily: GoogleFonts.notoSans().fontFamily,

ThemeData lightTheme = ThemeData.light();
ThemeData darkTheme = ThemeData.dark();

class ThemeService extends ChangeNotifier {
  ThemeService(this._themeData);

  ThemeData _themeData;
  get getTheme => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
