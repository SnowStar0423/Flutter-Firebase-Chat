import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/model/recent_chat.dart';
import 'package:chat_app/utils/app_global.dart';
import 'package:chat_app/utils/app_util.dart';
import 'package:chat_app/view/theme/app_color.dart';
import 'package:chat_app/viewmodel/chat_room_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/chat_user.dart';
import '../../model/recent_user_chat.dart';
import '../widgets/chat_room_item.dart';
import '../widgets/custom_textfield.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final ChatRoomViewModel _chatRoomViewModel = Get.find();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, dynamic> args = Get.arguments;
  late ChatUser _peer;
  String _groupChatId = "";

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  dispose() {
    super.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }

  init() {
    if (args.isNotEmpty) {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      if (args.containsKey('recentUserChat')) {
        RecentUserChat recentUserChat = args["recentUserChat"];
        RecentChat recentChat = recentUserChat.recentChat;
        _peer = recentUserChat.chatUser;

        _chatRoomViewModel.updateSeenRecentChat(
            currentUserId: currentUserId,
            peerId: _peer.id,
            recentChat: recentChat);
      } else {
        _peer = args["peer"];
      }

      _groupChatId =
          _chatRoomViewModel.generateGroupChatId(currentUserId, _peer.id);
      _chatRoomViewModel.loadMessages(_groupChatId);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          (_scrollController.position.maxScrollExtent * 0.7)) {
        _chatRoomViewModel.loadMessages(_groupChatId);
      }
    });
    AppUtil.debugPrint(_groupChatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(_peer.displayName),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 90),
        child: _buildChats(),
      ),
      floatingActionButton: _buildFooter(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  _buildChats() {
    return Obx(() => ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemBuilder: (context, index) {
            var msg = _chatRoomViewModel.chatMessages[index];
            return ChatRoomBox(message: msg);
          },
          shrinkWrap: true,
          itemCount: _chatRoomViewModel.chatMessages.length,
        ));
  }

  _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.add,
          //     color: AppColor.primary,
          //     size: 30,
          //   ),
          // ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: CustomTextField(
              controller: _messageController,
              hintText: "Write your message",
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: () async {
                // final res = await _chatRoomViewModel.sendChatMessage(
                //     content: _messageController.text,
                //     type: ChatMessageType.text,
                //     groupChatId: _groupChatId,
                //     currentUserId: FirebaseAuth.instance.currentUser!.uid,
                //     peerId: _peer.id);
                final res = await _chatRoomViewModel
                    .sendChatMessageWithPushNotification(
                        content: _messageController.text,
                        type: ChatMessageType.text,
                        groupChatId: _groupChatId,
                        currentUser: AppGlobal().firebaseUserToChatUser(
                            FirebaseAuth.instance.currentUser!),
                        peer: _peer);
                if (!res) {
                  AppUtil.showSnackBar("failed to send a message");
                }
                _messageController.clear();
              },
              icon: Icon(
                Icons.send_rounded,
                color:
                    _chatRoomViewModel.sending ? Colors.grey : AppColor.primary,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}
