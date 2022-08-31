import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/shared/nav_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final SettingsService settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeService>(context);
    bool isDarkTheme = themeProvider.getTheme == darkTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.hourglass,
              size: 150,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Welcome back.",
                textScaleFactor: 2,
              ),
            ),
            Text(
              "Logged in as ${AuthService().getUsername()}",
            ),
            TextButton(
              onPressed: () {
                AuthService().signOut();
              },
              child: const Text("Logout"),
            ),
            IconButton(
              onPressed: (() {
                settingsService
                    .updateSettings(UserSettings(isDarkTheme: !isDarkTheme));
                themeProvider.setTheme(isDarkTheme ? lightTheme : darkTheme);
              }),
              icon: Icon(
                isDarkTheme ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(
          currentIndex: 2,
        ),
      ),
    );
  }
}
