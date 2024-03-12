import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sinking_us/core/network/firestore_base.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';

class OpenChatDataSource {
  final FirestoreBase _firestoreBase = FirestoreBase();
  
  // Future<List<ChatUserModel>> getOpenChatUsers({required String chatID}) async {
  //   final chatUsers = await FirestoreBase().getOpenChatUsers(chatID);
  //   List<ChatUserModel> convertedUsers = [];
  //   for(DocumentSnapshot<Map<String, dynamic>> chatUser in chatUsers){
  //     convertedUsers.add(ChatUserModel.fromJson(chatUser.data()!));
  //   }
  //   return convertedUsers;
  // }

  // Stream<QuerySnapshot<Map<String, dynamic>>> chatUserStream(String chatID) {
  //   return FirestoreBase().chatUserStream(chatID);
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String chatID) {
    return _firestoreBase.chatStream(chatID);
  }

  Future<void> sendMsg(String chatID, {required ChatModel chat}) async {
    await _firestoreBase.sendMsg(chatID, chat: chat);
  }

  Future<void> joinChatRoom(String chatID, {required String nick}) async {
    return await _firestoreBase.joinChatRoom(chatID, nick: nick);
  }

  // void recordJoinedOpenChatRoom({required OpenChatModel openChatRoom, required String idToken}) {
  //   FirestoreBase().recordJoinedOpenChatRoom(openChatRoom: openChatRoom, idToken: idToken);
  // }

  // void deleteJoinedOpenChatRoom({required OpenChatModel openChatRoom, required String idToken}) {
  //   FirestoreBase().deleteJoinedOpenChatRoom(openChatRoom: openChatRoom, idToken: idToken);
  // }

  Future<void> outChatRoom(String chatID, {required String nick}) async {
    await FirestoreBase().outChatRoom(chatID, nick: nick);
  }
}