import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tempus/services/firestore/firestore.dart';

import '../auth.dart';

class TasksService {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks(DateTime date) {
    User user = AuthService().user!;
    return _db
        .collection('tasks')
        .where('uid', isEqualTo: user.uid)
        .where('date', isEqualTo: firestoreService.formatDate(date))
        .snapshots();
  }

  Future<void> addTask(DateTime date, int order) async {
    User user = AuthService().user!;

    var value = await _db.collection('tasks').add({
      'uid': user.uid,
      'date': firestoreService.formatDate(date),
      'detail': '',
      'order': order,
      'completed': false,
    });
  }
}
