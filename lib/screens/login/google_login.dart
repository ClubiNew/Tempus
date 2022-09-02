import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_button.dart';

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
        } on PlatformException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Sorry, an error occurred while opening the login dialogue. Ensure 3rd-party cookies are enabled.",
            ),
          ));
        } on Exception catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Sorry, an unknown error occurred. Please try again or use a different login method.",
            ),
          ));
          print(e);
        }
      },
    );
  }
}
