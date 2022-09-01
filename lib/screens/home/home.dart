import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/shared/nav_bar.dart';
import 'package:tempus/shared/theme.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final SettingsService settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    var themeState = Provider.of<ThemeState>(context);
    bool isDarkTheme = themeState.activeTheme == darkTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          IconButton(
            icon: isDarkTheme
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.nights_stay),
            tooltip: "Toggle theme",
            onPressed: () {
              settingsService
                  .updateSettings(UserSettings(isDarkTheme: !isDarkTheme));
              themeState.setTheme(isDarkTheme ? lightTheme : darkTheme);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              AuthService().signOut();
            },
          )
        ],
      ),
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
