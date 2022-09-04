import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/models/models.dart';
import 'package:tempus/shared/shared.dart';

import 'progress.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();

  final SettingsService settingsService = SettingsService();
  late UserSettings settings;
  bool saved = true;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      saved = !focusNode.hasFocus;
      if (saved) {
        settings.stickyNote = controller.text;
        settingsService.saveSettings(settings);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    settings = Provider.of<UserSettings>(context);
    if (saved) {
      controller.text = settings.stickyNote;
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
      ),
      body: GestureDetector(
        onTap: focusNode.unfocus,
        child: CardList(
          children: [
            PaddedCard(
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
                            builder: (context) => ThemeSettingsScreen(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const ProgressCard(),
            PaddedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sticky note",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 5,
                    maxLines: null,
                    onEditingComplete: () {
                      focusNode.unfocus();
                    },
                    onSubmitted: (_) {
                      focusNode.unfocus();
                    },
                  ),
                ],
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
