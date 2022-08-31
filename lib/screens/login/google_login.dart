import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tempus/screens/screens.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return LoginButton(
      text: "Login with Google",
      icon: FontAwesomeIcons.google,
      buttonColor: colorScheme.primary,
      loginMethod: () async {
        try {
          final googleUser = await GoogleSignIn().signIn();

          if (googleUser == null) return;

          final googleAuth = await googleUser.authentication;
          final authCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await FirebaseAuth.instance.signInWithCredential(authCredential);
        } on Exception catch (e) {
          print("Google login failed: $e");
        }
      },
    );
  }
}
