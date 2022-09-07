import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempus/models/pages.dart';
import 'package:tempus/services/auth.dart';
import 'package:tempus/services/date_format.dart';

class PageCollections {
  static const String tasks = 'tasks';
  static const String notes = 'notes';
}

class PageService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final AuthService _authService = AuthService();
  final String collectionName;

  PageService(this.collectionName);

  DocumentReference<Map<String, dynamic>> _getDoc(DateTime date) {
    return _db
        .collection('pages')
        .doc(_authService.user!.uid)
        .collection(collectionName)
        .doc(getFirestoreDate(date));
  }

  Stream<OrderedPage> getPage(DateTime date) {
    var snapshotStream = _getDoc(date).snapshots();
    return snapshotStream
        .map((snapshot) => OrderedPage.fromJson(snapshot.data() ?? {}));
  }

  Future savePage(OrderedPage page, DateTime date) async {
    await _getDoc(date).set(page.toJson());
  }
}
