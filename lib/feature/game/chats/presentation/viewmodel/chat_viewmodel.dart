import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';
import 'package:sinking_us/feature/game/chats/domain/chat_domain.dart';
import 'package:sinking_us/helpers/constants/app_sounds.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'chat_viewmodel.g.dart';

class OpenChatViewModelState {
  OpenChatViewModelState({
    this.chatStream,
    required this.chatController,
    required this.chatNode,
    required this.gameNode,
    required this.userInfo,
    required this.chatID,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream;
  TextEditingController chatController;
  FocusNode chatNode;
  FocusNode gameNode;
  UserInfoModel? userInfo;
  String chatID;
}

@Riverpod(keepAlive: true)
class OpenChatViewModelController extends _$OpenChatViewModelController {
  DateTime lastPush = DateTime.now();

  @override
  OpenChatViewModelState build() {
    return OpenChatViewModelState(
      chatController: TextEditingController(),
      chatNode: FocusNode(),
      gameNode: FocusNode(),
      userInfo: ref.watch(userDomainControllerProvider).userInfo,
      chatID: ""
    );
  }

  void setState() {
    state = OpenChatViewModelState(
      chatStream: state.chatStream,
      chatController: state.chatController,
      chatNode: state.chatNode,
      gameNode: state.gameNode,
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
      if(state.chatController.text.length > 500) {
        return ShowDialogHelper.showSnackBar(content: tr('gamePage_2much'));
      }
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
        state.chatController.text = '';
        state.chatNode.requestFocus();
        setState();
        lastPush = DateTime.now();
      } else {
        ShowDialogHelper.showSnackBar(content: tr('gamePage_2fast'));
      }
    }
  }

  void outSideTap() {
    state.chatNode.unfocus();
    state.gameNode.requestFocus();
    print('hello');
  }
}