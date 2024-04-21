import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';

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

  //open chat
  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String chatID) {
    return _firestore!.collection("openchat").doc(chatID).collection("chat").orderBy('time', descending: true).limit(20).snapshots();
  }

  Future<void> joinChatRoom(String chatID, {required String nick}) async {
    //오픈챗방에 추가
    await _firestore!.collection("openchat").doc(chatID).collection("chat").add(
      ChatModel(
        content: "[$nick] has entered.", 
        nick: nick, 
        role: "server",
        time: DateTime.now()
      ).toJson()
    );
    //인원체크 후 리턴 bool
  }

  Future<void> outChatRoom(String chatID, {required String nick}) async {
    //오픈챗방에 추가
    await _firestore!.collection("openchat").doc(chatID).collection("chat").add(
      ChatModel(
        content: "[$nick] has left the game.", 
        nick: nick, 
        role: "server",
        time: DateTime.now()
      ).toJson()
    );
    //인원체크 후 리턴 bool
  }

  Future<void> sendMsg(String chatID, {required ChatModel chat}) async {
    await _firestore!.collection("openchat").doc(chatID).collection("chat").add(chat.toJson());
  }

  Future<String?> getDownloadApkLink() async {
    await _firestore!.collection("download").doc("android").get().then((value) {
      return value['apk'];
    });
    return null;
  }

  Future<String?> getDownloadIosLink() async {
    await _firestore!.collection("download").doc("ios").get().then((value) {
      return value['ios'];
    });
    return null;
  }
}