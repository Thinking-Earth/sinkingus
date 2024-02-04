import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreBase {
  static FirebaseFirestore? _firestore;
  static FirestoreBase? _firestoreBase;

  factory FirestoreBase() => _firestoreBase ?? const FirestoreBase._();
  const FirestoreBase._();

  static void init() {
    _firestore = FirebaseFirestore.instance;
  }
}