import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempus/models/settings.dart';
import 'package:tempus/services/auth.dart';

class SettingsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Stream<UserSettings> getSettings() {
    String uid = _authService.user!.uid;
    return _db.collection('settings').doc(uid).snapshots().map((snapshot) {
      return snapshot.data() == null
          ? UserSettings()
          : UserSettings.fromJson(snapshot.data()!);
    });
  }

  Future saveSettings(UserSettings settings) async {
    String uid = _authService.user!.uid;
    await _db.collection('settings').doc(uid).set(settings.toJson());
  }
}
