import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/login/login.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/theme.dart';
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
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) =>
              RequestBuilder<User?>(
            snapshot: snapshot,
            mountSpinner: true,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoginScreen();
              } else {
                return MultiProvider(
                  providers: [
                    StreamProvider(
                      initialData: UserSettings(),
                      create: (context) =>
                          SettingsService().getUserSettings(snapshot.data!.uid),
                    ),
                    StreamProvider(
                      initialData: PomodoroSettings(saved: false),
                      create: (context) =>
                          SettingsService().getPomodoroSettings(),
                    ),
                  ],
                  builder: (context, _) {
                    UserSettings settings = Provider.of<UserSettings>(context);
                    ColorOption selectedColor =
                        colorOptions[settings.colorTheme];
                    return MaterialApp(
                      title: "Tempus",
                      routes: appRoutes,
                      theme: ThemeData(
                        colorScheme: ColorScheme.fromSwatch(
                          primarySwatch: selectedColor.primaryColor,
                          accentColor: settings.darkMode
                              ? selectedColor.accentColor
                              : selectedColor.primaryColor,
                          brightness: settings.darkMode
                              ? Brightness.dark
                              : Brightness.light,
                        ),
                        fontFamily: 'Roboto',
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
