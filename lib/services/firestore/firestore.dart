import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tempus/services/auth.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }
}
