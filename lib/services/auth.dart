import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  String getUsername() {
    return user?.displayName ?? user?.email ?? user?.phoneNumber ?? 'Anonymous';
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
