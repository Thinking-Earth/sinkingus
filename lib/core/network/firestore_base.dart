import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';

@immutable
class FirestoreBase {
  static FirebaseFirestore? _firestore;
  static FirestoreBase? _firestoreBase;

  factory FirestoreBase() => _firestoreBase ?? const FirestoreBase._();
  const FirestoreBase._();

  static void init() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<UserInfoModel?> getUserInfo({required String email}) async {
    try {
      DocumentSnapshot snapshot = await _firestore!.collection("users").doc(email).get();
      return UserInfoModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInFirestore({required UserInfoModel userInfo}) async {
    await _firestore!.collection("users").doc(userInfo.email).set(userInfo.toJson());
  }
}