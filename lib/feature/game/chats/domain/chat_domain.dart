import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/chats/data/datasource/chat_datasource.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';

part 'chat_domain.g.dart';

class ChatDomainState {
  ChatDomainState({
    required this.userInfo,
    required this.openChatDataSource
  });

  UserInfoModel? userInfo;
  OpenChatDataSource openChatDataSource;
}

@riverpod
class ChatDomainController extends _$ChatDomainController {
  @override
  ChatDomainState build() {
    return ChatDomainState(
      userInfo: ref.watch(userDomainControllerProvider).userInfo,
      openChatDataSource: OpenChatDataSource()
    );
  }

  void setState() {
    state = ChatDomainState(
      userInfo: state.userInfo,
      openChatDataSource: state.openChatDataSource
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String chatID) {
    return state.openChatDataSource.chatStream(chatID);
  }

  Future<void> sendMsg(String chatID, {required ChatModel chat}) async {
    await state.openChatDataSource.sendMsg(chatID, chat: chat);
  }

  Future<void> joinChatRoom(String chatID, {required String nick}) async {
    await state.openChatDataSource.joinChatRoom(chatID, nick: nick);
  }

  Future<void> outChatRoom(String chatID, {required String nick}) async {
    await state.openChatDataSource.outChatRoom(chatID, nick: nick);
  }
}