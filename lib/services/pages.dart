import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempus/models/pages.dart';
import 'package:tempus/services/auth.dart';

class PageCollections {
  static const String tasks = 'tasks';
  static const String journals = 'journals';
}

class PageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final String collectionName;

  PageService(this.collectionName);

  DocumentReference<Map<String, dynamic>> _getDoc(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return _db
        .collection('pages')
        .doc(_authService.user!.uid)
        .collection(collectionName)
        .doc("${date.year}-$month-$day");
  }

  Stream<OrderedPage> getPage(DateTime date) {
    var snapshotStream = _getDoc(date).snapshots();
    return snapshotStream.map((snapshot) => snapshot.data() != null
        ? OrderedPage.fromJson(snapshot.data()!)
        : OrderedPage([]));
  }

  Future savePage(OrderedPage page, DateTime date) async {
    await _getDoc(date).set(page.toJson());
  }
}
