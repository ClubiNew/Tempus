import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempus/services/auth.dart';
import 'package:tempus/services/firestore/firestore.dart';

import 'models.dart';

class SettingsService {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserSettings> getSettings() async {
    var doc =
        await _db.collection("settings").doc(AuthService().user!.uid).get();
    if (doc.data() == null) {
      return UserSettings();
    } else {
      return UserSettings.fromJson(doc.data()!);
    }
  }

  Future<void> updateSettings(UserSettings settings) async {
    String uid = AuthService().user!.uid;
    await _db.collection("settings").doc(uid).set(settings.toJson());
  }
}
