import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tempus/services//auth.dart';
import 'package:tempus/shared/date.dart';
import 'models.dart';

class TasksService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Query<Map<String, dynamic>> _getTasksQuery(DateTime date) {
    return _db
        .collection('tasks')
        .where('uid', isEqualTo: AuthService().user!.uid)
        .where('date', isEqualTo: getFirestoreDateString(date));
  }

  List<Task> _mapTasks(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return Task.fromJson(data);
    }).toList();
  }

  Future<List<Task>> getTasks(DateTime date) async {
    var snapshot = await _getTasksQuery(date).get();
    return _mapTasks(snapshot);
  }

  Stream<List<Task>> getTasksStream(DateTime date) {
    return _getTasksQuery(date).snapshots().map(_mapTasks);
  }

  Future addTask(DateTime date, int order) async {
    User user = AuthService().user!;

    var value = await _db.collection('tasks').add({
      'uid': user.uid,
      'date': getFirestoreDateString(date),
      'detail': '',
      'order': order,
      'completed': false,
    });
  }

  Future updateTask(Task task) async {
    var doc = _db.collection('tasks').doc(task.id);
    await doc.update(task.toJson());
  }

  Future moveTask(List<Task> tasks, int oldIndex, int newIndex) async {
    Task selectedTask = tasks.firstWhere((task) => task.order == oldIndex);
    List<Task> updatedTasks = [selectedTask];

    // the newIndex/oldIndex are inconsistent depending on direction
    if (newIndex < oldIndex) {
      newIndex--;
    }

    int from = min(oldIndex, newIndex);
    int to = max(oldIndex, newIndex);
    int direction = oldIndex < newIndex ? -1 : 1;

    for (Task task in tasks) {
      if (from < task.order && task.order < to) {
        task.order += direction;
        updatedTasks.add(task);
      }
    }

    selectedTask.order = newIndex + direction;

    // update in DB
    WriteBatch batch = FirebaseFirestore.instance.batch();
    var collection = _db.collection('tasks');

    for (Task task in updatedTasks) {
      var doc = collection.doc(task.id);
      batch.update(doc, task.toJson());
    }

    await batch.commit();
  }

  Future transferIncomplete(DateTime toDate, int order) async {
    DateTime fromDate = toDate.subtract(const Duration(days: 1));
    User user = AuthService().user!;

    var snapshot = await _db
        .collection('tasks')
        .where('uid', isEqualTo: user.uid)
        .where('date', isEqualTo: getFirestoreDateString(fromDate))
        .where('completed', isEqualTo: false)
        .get();

    List<Task> transferTasks =
        snapshot.docs.map<Task>((doc) => Task.fromJson(doc.data())).toList();
    transferTasks.sort((a, b) => a.order.compareTo(b.order));

    for (Task fromTask in transferTasks) {
      _db.collection('tasks').add({
        'uid': user.uid,
        'date': getFirestoreDateString(toDate),
        'detail': fromTask.detail,
        'order': order,
        'completed': false,
      });

      order++;
    }
  }

  Future deleteTask(List<Task> tasks, Task deleteTask) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    var collection = _db.collection('tasks');

    for (Task task in tasks) {
      if (task.order > deleteTask.order) {
        task.order--;
        var doc = collection.doc(task.id);
        batch.update(doc, task.toJson());
      }
    }

    batch.delete(collection.doc(deleteTask.id));
    await batch.commit();
  }
}
