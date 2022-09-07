import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempus/models/models.dart';
import 'package:tempus/services/auth.dart';

class GoalService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final AuthService _authService = AuthService();

  CollectionReference<Map<String, dynamic>> _getGoalsCollection() {
    return _db
        .collection('pages')
        .doc(_authService.user!.uid)
        .collection('goals');
  }

  Stream<Map<String, Goal>> getGoals() {
    return _getGoalsCollection().snapshots().map(
      (snapshot) {
        Map<String, Goal> goals = {};

        for (var docSnapshot in snapshot.docs) {
          goals[docSnapshot.id] = Goal.fromJson(docSnapshot.data());
        }

        return goals;
      },
    );
  }

  Future createGoal(Goal goal) {
    return _getGoalsCollection().add(goal.toJson());
  }

  Future updateGoal(String id, Goal goal) {
    return _getGoalsCollection().doc(id).update(goal.toJson());
  }

  Future deleteGoal(String id) {
    return _getGoalsCollection().doc(id).delete();
  }
}
