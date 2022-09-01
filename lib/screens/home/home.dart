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
    var themeProvider = Provider.of<ThemeState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          PopupMenuButton<ColorOption>(
            icon: const Icon(Icons.palette),
            onSelected: (ColorOption option) {
              int colorTheme = colorOptions.indexOf(option);
              settingsService.updateSettings(UserSettings(
                isDarkTheme: themeProvider.isDarkTheme,
                colorTheme: colorTheme,
              ));
              themeProvider.setColor(colorTheme);
            },
            itemBuilder: (context) => colorOptions
                .map(
                  (option) => PopupMenuItem<ColorOption>(
                    value: option,
                    child: Text(option.name),
                  ),
                )
                .toList(),
          ),
          IconButton(
            icon: themeProvider.isDarkTheme
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.nights_stay),
            tooltip: "Toggle theme",
            onPressed: () {
              bool isDarkTheme = themeProvider.isDarkTheme;
              settingsService.updateSettings(UserSettings(
                isDarkTheme: !isDarkTheme,
                colorTheme: themeProvider.colorTheme,
              ));
              themeProvider.setDarkMode(!isDarkTheme);
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
