import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/login/login.dart';
import 'package:tempus/routes.dart';
import 'package:tempus/services/auth.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:tempus/services/firestore/settings.dart';
import 'package:tempus/services/theme.dart';
import 'package:tempus/shared/loading.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Error(
            snapshot: snapshot,
          );
        } else if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingScreen();
        } else {
          return StreamBuilder(
            stream: AuthService().userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Error(
                  snapshot: snapshot,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (!snapshot.hasData) {
                return const LoginScreen();
              } else {
                return FutureBuilder(
                  future: SettingsService().getSettings(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return Error(
                        snapshot: snapshot,
                      );
                    } else if (snapshot.connectionState !=
                        ConnectionState.done) {
                      return const LoadingScreen();
                    } else {
                      UserSettings settings = snapshot.data as UserSettings;
                      return MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                              create: (_) => ThemeService(settings.isDarkTheme
                                  ? darkTheme
                                  : lightTheme)),
                        ],
                        child: const ThemedApp(),
                      );
                    }
                  }),
                );
              }
            },
          );
        }
      }),
    );
  }
}

class ThemedApp extends StatelessWidget {
  const ThemedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeService>(context);
    return MaterialApp(
      routes: appRoutes,
      theme: themeProvider.getTheme,
    );
  }
}

class Error extends StatelessWidget {
  const Error({required this.snapshot, Key? key}) : super(key: key);
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${snapshot.error}',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
