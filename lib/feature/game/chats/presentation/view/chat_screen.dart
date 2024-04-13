import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';
import 'package:sinking_us/feature/game/chats/presentation/viewmodel/chat_viewmodel.dart';
import 'package:sinking_us/feature/game/chats/presentation/widgets/chat_inputter.dart';
import 'package:sinking_us/feature/game/chats/presentation/widgets/mychat_bubble.dart';
import 'package:sinking_us/feature/game/chats/presentation/widgets/notmychat_bubble.dart';
import 'package:sinking_us/feature/game/chats/presentation/widgets/serverchat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.chatID});

  final String chatID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(openChatViewModelControllerProvider.notifier).setUpChatScreen(chatID: widget.chatID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = ref.watch(openChatViewModelControllerProvider);
    final userInfo = ref.read(userDomainControllerProvider).userInfo;

    return Container(
      width: 240.w, 
      height: 140.h,
      padding: EdgeInsets.only(left: 8.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(71, 0, 0, 0),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatViewModel.chatStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.data != null) {
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final ChatModel chat = ChatModel.fromJson(Map<String, dynamic>.from(snapshot.data!.docs[index].data() as Map));
                        if(chat.role == "server") {
                          return serverChatBubble(chat);
                        } else if(chat.nick == userInfo!.nick) {
                          return myChatBubble(chat);
                        } else {
                          return notMyChatBubble(chat);
                        }
                      } 
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ),
          chatInputter(
            textController: chatViewModel.chatController,
            focusNode: chatViewModel.chatNode,
            onTap: ref.read(openChatViewModelControllerProvider.notifier).sendMsg,
            outsideTap: ref.read(openChatViewModelControllerProvider.notifier).outSideTap
          ),
        ],
      ),
    );
  }
}