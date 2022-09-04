import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/models/settings.dart';
import 'package:tempus/services/settings.dart';
import 'package:tempus/shared/shared.dart';
import 'package:tempus/theme.dart';

class ThemeSettingsScreen extends StatelessWidget {
  ThemeSettingsScreen({Key? key}) : super(key: key);
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
