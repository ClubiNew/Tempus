import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:tempus/services/firestore/settings.dart';
import 'package:tempus/shared/shared.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserSettings settings = Provider.of<UserSettings>(context);
    ColorOption selectedColor = colorOptions[settings.colorTheme];
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12.0),
          PaddedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Theme", style: theme.textTheme.titleLarge),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: theme.textTheme.subtitle1,
                    ),
                    Switch(
                      activeColor: theme.colorScheme.primary,
                      value: settings.isDarkTheme,
                      onChanged: (bool value) {
                        settings.isDarkTheme = value;
                        SettingsService().updateSettings(settings);
                      },
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Divider(),
                ),
                Text(
                  "Primary Color",
                  style: theme.textTheme.subtitle1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: colorOptions
                      .asMap()
                      .entries
                      .map((colorOptionEntry) => Row(
                            children: [
                              Radio<ColorOption>(
                                activeColor: theme.colorScheme.primary,
                                value: colorOptionEntry.value,
                                groupValue: selectedColor,
                                onChanged: (ColorOption? colorOption) {
                                  settings.colorTheme =
                                      colorOptions.indexOf(colorOption!);
                                  SettingsService().updateSettings(settings);
                                },
                              ),
                              Text(colorOptionEntry.value.name),
                            ],
                          ))
                      .toList(),
                )
              ],
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
