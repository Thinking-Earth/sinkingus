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
    DocumentSnapshot snapshot = await _firestore!.collection("users").doc(email).get();
    // return UserInfoModel(
    //   email: email, 
    //   nick: snapshot['nick'], 
    //   profileURL: snapshot['profileURL'], 
    //   uid: snapshot['uid']
    // );
    //플러터 내부 버그
    return UserInfoModel.fromJson(Map<String, dynamic>.from(snapshot.data() as Map));
  }

  Future<void> signInFirestore({required UserInfoModel userInfo}) async {
    await _firestore!.collection("users").doc(userInfo.email).set(userInfo.toJson());
  }
}