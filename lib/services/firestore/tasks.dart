import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tempus/services/firestore/firestore.dart';
import 'package:tempus/services//auth.dart';
import 'models.dart';

class TasksService {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(DateTime date) {
    var docStream = _db
        .collection('tasks')
        .where('uid', isEqualTo: AuthService().user!.uid)
        .where('date', isEqualTo: firestoreService.formatDate(date))
        .snapshots();

    return docStream.map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Task.fromJson(data);
      }).toList();
    });
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

  Future<void> updateTask(Task task) async {
    var doc = _db.collection('tasks').doc(task.id);
    await doc.update(task.toJson());
  }

  Future<void> updateMany(List<Task> tasks) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    var collection = _db.collection('tasks');

    for (Task task in tasks) {
      var doc = collection.doc(task.id);
      batch.update(doc, task.toJson());
    }

    await batch.commit();
  }
}
