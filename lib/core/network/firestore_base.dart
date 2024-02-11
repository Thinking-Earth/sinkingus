import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class FirestoreBase {
  static FirebaseFirestore? _firestore;
  static FirestoreBase? _firestoreBase;

  factory FirestoreBase() => _firestoreBase ?? const FirestoreBase._();
  const FirestoreBase._();

  static void init() {
    _firestore = FirebaseFirestore.instance;
  }
}