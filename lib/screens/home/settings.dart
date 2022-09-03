import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:tempus/services/firestore/settings.dart';
import 'package:tempus/shared/shared.dart';
import 'package:tempus/theme.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserSettings settings = Provider.of<UserSettings>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: false,
      ),
      body: CardList(
        children: [
          SettingsCard(
            title: "Theme",
            settings: [
              Setting(
                title: "Dark Mode",
                child: Switch(
                  activeColor: theme.colorScheme.primary,
                  value: settings.darkMode,
                  onChanged: (bool value) {
                    settings.darkMode = value;
                    SettingsService().updateUserSettings(settings);
                  },
                ),
              ),
              Setting(
                title: "Color Theme",
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: DropdownButton<int>(
                    value: settings.colorTheme,
                    elevation: 4,
                    isExpanded: true,
                    onChanged: (int? colorOptionIdx) {
                      settings.colorTheme = colorOptionIdx!;
                      SettingsService().updateUserSettings(settings);
                    },
                    items: colorOptions
                        .asMap()
                        .entries
                        .map(
                          (colorOption) => DropdownMenuItem(
                            value: colorOption.key,
                            child: Row(
                              children: [
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
