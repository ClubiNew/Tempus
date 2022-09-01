import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/login/login.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/shared/theme.dart';
import 'package:tempus/shared/loading.dart';
import 'package:tempus/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) => RequestBuilder(
        snapshot: snapshot,
        mountSpinner: true,
        builder: (context, snapshot) => StreamBuilder(
          stream: AuthService().userStream,
          builder: (context, snapshot) => RequestBuilder(
            snapshot: snapshot,
            mountSpinner: true,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoginScreen();
              } else {
                return FutureBuilder(
                  future: SettingsService().getSettings(),
                  builder: (context, snapshot) => RequestBuilder(
                    snapshot: snapshot,
                    mountSpinner: true,
                    builder: (context, snapshot) {
                      UserSettings settings = snapshot.data as UserSettings;
                      return MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (context) => ThemeState(
                              settings.isDarkTheme ? darkTheme : lightTheme,
                            ),
                          ),
                        ],
                        child: const ThemedApp(),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ThemedApp extends StatelessWidget {
  const ThemedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);
    return MaterialApp(
      title: "Tempus",
      routes: appRoutes,
      theme: themeState.activeTheme,
    );
  }
}
