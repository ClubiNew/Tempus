import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempus/services/auth.dart';

import 'models.dart';

class SettingsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserSettings> getUserSettings(String uid) {
    return _db.collection("userSettings").doc(uid).snapshots().map((snapshot) {
      return snapshot.data() == null
          ? UserSettings()
          : UserSettings.fromJson(snapshot.data()!);
    });
  }

  Future<void> updateUserSettings(UserSettings settings) async {
    String uid = AuthService().user!.uid;
    await _db.collection("userSettings").doc(uid).set(settings.toJson());
  }

  Stream<PomodoroSettings> getPomodoroSettings() {
    return _db
        .collection("pomodoroSettings")
        .doc(AuthService().user!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.data() == null
          ? PomodoroSettings()
          : PomodoroSettings.fromJson(snapshot.data()!);
    });
  }

  Future<void> updatePomodoroSettings(PomodoroSettings settings) async {
    String uid = AuthService().user!.uid;
    await _db.collection("pomodoroSettings").doc(uid).set(settings.toJson());
  }
}
