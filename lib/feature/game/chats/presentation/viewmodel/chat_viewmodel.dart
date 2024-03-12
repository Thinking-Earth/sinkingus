import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';
import 'package:sinking_us/feature/game/chats/domain/chat_domain.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'chat_viewmodel.g.dart';

class OpenChatViewModelState {
  OpenChatViewModelState({
    this.chatStream,
    required this.chatController,
    required this.focusNode,
    required this.userInfo,
    required this.chatID
  });

  Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream;
  TextEditingController chatController;
  FocusNode focusNode;
  UserInfoModel? userInfo;
  String chatID;
}

@riverpod
class OpenChatViewModelController extends _$OpenChatViewModelController {
  DateTime lastPush = DateTime.now();

  @override
  OpenChatViewModelState build() {
    return OpenChatViewModelState(
      chatController: TextEditingController(),
      focusNode: FocusNode(),
      userInfo: ref.watch(userDomainControllerProvider).userInfo,
      chatID: ""
    );
  }

  void setState() {
    state = OpenChatViewModelState(
      chatStream: state.chatStream,
      chatController: state.chatController,
      focusNode: state.focusNode,
      userInfo: state.userInfo,
      chatID: state.chatID
    );
  }

  void setUpChatScreen({required String chatID}) {
    state.chatStream = ref.read(chatDomainControllerProvider.notifier).chatStream(chatID);
    state.chatID = chatID;
    ref.read(chatDomainControllerProvider.notifier).joinChatRoom(chatID, nick: state.userInfo!.nick);
    setState();
  }

  void outChat() {
    ref.read(chatDomainControllerProvider.notifier).outChatRoom(state.chatID, nick: state.userInfo!.nick);
  }

  void sendMsg() async {
    if(state.chatController.text != "") {
      if(DateTime.now().millisecondsSinceEpoch - lastPush.millisecondsSinceEpoch > 1000) {
        await ref.read(chatDomainControllerProvider.notifier).sendMsg(
          state.chatID, 
          chat: ChatModel(
            content: state.chatController.text, 
            nick: state.userInfo!.nick, 
            role: "test",
            time: DateTime.now()
          )
        );
        state.chatController.clear();
        setState();
        FocusScope.of(AppRouter.navigatorKey.currentContext!).requestFocus(state.focusNode);
        lastPush = DateTime.now();
      } else {
        ShowDialogHelper.showSnackBar(content: "조금만 천천히 입력해주세요.");
      }
    }
  }
}