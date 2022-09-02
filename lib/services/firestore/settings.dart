import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempus/services/auth.dart';

import 'models.dart';

class SettingsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserSettings> getSettings(String uid) {
    return _db.collection("settings").doc(uid).snapshots().map((snapshot) {
      return snapshot.data() == null
          ? UserSettings()
          : UserSettings.fromJson(snapshot.data()!);
    });
  }

  Future<void> updateSettings(UserSettings settings) async {
    String uid = AuthService().user!.uid;
    await _db.collection("settings").doc(uid).set(settings.toJson());
  }
}
