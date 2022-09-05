import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/models/models.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/shared/app_bar.dart';
import 'package:tempus/shared/cards.dart';
import 'package:tempus/theme.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return PaddedCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text("Logged in as ${authService.getUsername()}"),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: authService.signOut,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThemeSettings(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({Key? key}) : super(key: key);

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  final SettingsService settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    final UserSettings settings = Provider.of<UserSettings>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        allowNavigation: true,
      ),
      body: CardList(
        children: [
          SettingsCard(
            title: 'Theme',
            settings: [
              Setting(
                title: "Dark Mode",
                child: Switch(
                  activeColor: theme.colorScheme.primary,
                  value: settings.themeSettings.darkMode,
                  onChanged: (bool value) {
                    settings.themeSettings.darkMode = value;
                    settingsService.saveSettings(settings);
                  },
                ),
              ),
              Setting(
                title: "Color Theme",
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: DropdownButton<int>(
                    value: settings.themeSettings.color,
                    elevation: 4,
                    isExpanded: true,
                    onChanged: (int? colorOptionIdx) {
                      settings.themeSettings.color = colorOptionIdx!;
                      settingsService.saveSettings(settings);
                    },
                    items: colorOptions
                        .asMap()
                        .entries
                        .map(
                          (colorOption) => DropdownMenuItem(
                            value: colorOption.key,
                            child: Row(
                              children: [
                                const SizedBox(width: 8.0),
                                Container(
                                  height: 16.0,
                                  width: 16.0,
                                  decoration: BoxDecoration(
                                    color: colorOption.value.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(colorOption.value.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
