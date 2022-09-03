import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/home/settings.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/shared/progress_bar.dart';
import 'package:tempus/shared/shared.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final SettingsService _settingsService = SettingsService();

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late UserSettings settings;
  bool saved = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        settings.stickyNote = _controller.text;
        _settingsService.updateUserSettings(settings);
        saved = true;
      } else {
        saved = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<UserSettings>(context);
    ThemeData theme = Theme.of(context);

    if (!_focusNode.hasFocus && saved) {
      _controller.text = settings.stickyNote;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: _focusNode.unfocus,
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
                      Text("Logged in as ${_authService.getUsername()}"),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: "Logout",
                        onPressed: _authService.signOut,
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        tooltip: "Settings",
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UserSettingsScreen(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            PaddedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's progress",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Task>>(
                    future: TasksService().getTasks(DateTime.now()),
                    builder: (context, snapshot) => RequestBuilder<List<Task>>(
                      snapshot: snapshot,
                      builder: (context, snapshot) {
                        List<Task> tasks = snapshot.data!;
                        int completedTasks =
                            tasks.where((task) => task.completed).length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProgressBar(
                              value: tasks.isNotEmpty
                                  ? completedTasks / tasks.length
                                  : 0.0,
                            ),
                            Text(
                                "$completedTasks/${tasks.length} tasks completed",
                                style: theme.textTheme.labelMedium),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
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
                    controller: _controller,
                    focusNode: _focusNode,
                    minLines: 5,
                    maxLines: null,
                    maxLength: 1024,
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
