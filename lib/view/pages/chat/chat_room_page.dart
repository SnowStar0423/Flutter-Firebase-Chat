import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/core/utils/app_global.dart';
import 'package:chat_app/core/utils/app_route.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/core/utils/firebase_constant.dart';
import 'package:chat_app/view/theme/app_color.dart';
import 'package:chat_app/view/widgets/not_found.dart';
import 'package:chat_app/viewmodel/chat_room_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/view/widgets/chat_room_item.dart';
import 'package:chat_app/view/widgets/custom_textfield.dart';

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

  init() async {
    if (args.isNotEmpty) {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      _peer = args["peer"];
      _groupChatId =
          _chatRoomViewModel.generateGroupChatId(currentUserId, _peer.id);

      _chatRoomViewModel.checkIsUserBlocked(
          currentUserId: currentUserId, peerId: _peer.id);
      _chatRoomViewModel.loadMessages(_groupChatId);
      _chatRoomViewModel.checkIsBlockedPeer(
          currentUserId: currentUserId, peerId: _peer.id);

      if (args.containsKey('fromRoute') &&
          args["fromRoute"] == AppRoute.chatPage) {
        _chatRoomViewModel.updateRecentChatSeen(
            currentUserId: currentUserId, peerId: _peer.id);
      }
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
    return Obx(
      () => _chatRoomViewModel.isBlocked
          ? const NotFound()
          : Scaffold(
              appBar: _buildAppBar(),
              body: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom > 0 ? 80 : 70,
                ),
                child: _buildChats(),
              ),
              floatingActionButton: _buildFooter(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterDocked,
            ),
    );
  }

  _buildPeerOnlineStatus() {
    return StreamBuilder(
        stream: _chatRoomViewModel.loadPeerOnlineStatus(_peer.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var peer = ChatUser.fromJson(snapshot.data!.data()!);
            return Column(
              children: [
                Text(_peer.displayName),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    peer.onlineStatus == null ||
                            peer.onlineStatus == UserOnlineStatus.offline
                        ? const Icon(
                            Icons.cancel,
                            size: 11,
                            color: UserOnlineStatus.offlineColor,
                          )
                        : const Icon(
                            Icons.check_circle,
                            size: 11,
                            color: UserOnlineStatus.onlineColor,
                          ),
                    const SizedBox(width: 3),
                    Text(
                      peer.onlineStatus ?? UserOnlineStatus.offline,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: _buildPeerOnlineStatus(),
      actions: [
        IconButton(
          onPressed: _onUserAction,
          icon: const Icon(Icons.more_horiz),
        )
      ],
    );
  }

  _onUserAction() async {
    await AppUtil.showUserActionsDialog(
      context,
      onRepot: _onReportUser,
      block: _chatRoomViewModel.isBlockedPeer ? "Unblock" : "Block",
      onBlock: _onBlockUser,
      onCancel: () {
        Get.back();
      },
    );
  }

  _onReportUser() {
    Get.back();
    _chatRoomViewModel.reportUser(
        currentUserId: FirebaseAuth.instance.currentUser!.uid,
        peerId: _peer.id);
    AppUtil.showSnackBar(
      _chatRoomViewModel.message,
      duration: 3,
    );
  }

  _onBlockUser() async {
    Get.back();
    _chatRoomViewModel.toggleBlockPeer(
        currentUserId: FirebaseAuth.instance.currentUser!.uid,
        peerId: _peer.id);

    AppUtil.showSnackBar(
      _chatRoomViewModel.message,
      duration: 3,
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
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
        () => _chatRoomViewModel.isBlockedPeer || _chatRoomViewModel.isBlocked
            ? _buildCheckBlocked()
            : _SendMessageBlock(
                groupChatId: _groupChatId,
                peer: _peer,
                messageController: _messageController,
              ),
      ),
    );
  }

  _buildCheckBlocked() {
    if (_chatRoomViewModel.isBlockedPeer) {
      return _UnblockButton(peer: _peer);
    }
    return const SizedBox();
  }
}

class _SendMessageBlock extends StatelessWidget {
  _SendMessageBlock(
      {required this.groupChatId,
      required this.peer,
      required this.messageController});
  final _chatRoomViewModel = Get.find<ChatRoomViewModel>();
  final String groupChatId;
  final ChatUser peer;
  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            _chatRoomViewModel.browseImage();
          },
          icon: const Icon(
            Icons.image_outlined,
            color: AppColor.primary,
            size: 30,
          ),
        ),
        // const SizedBox(
        //   width: 20,
        // ),
        Expanded(
          child: CustomTextField(
            controller: messageController,
            maxLines: 5,
            hintText: "Write your message",
          ),
        ),
        IconButton(
          onPressed: () async {
            final res =
                await _chatRoomViewModel.sendChatMessageWithPushNotification(
                    content: messageController.text,
                    type: ChatMessageType.text,
                    groupChatId: groupChatId,
                    currentUser: AppGlobal().firebaseUserToChatUser(
                        FirebaseAuth.instance.currentUser!),
                    peer: peer);
            if (!res) {
              AppUtil.showSnackBar("failed to send a message");
            }
            messageController.clear();
          },
          icon: Icon(
            Icons.send_rounded,
            color: _chatRoomViewModel.sending ? Colors.grey : AppColor.primary,
            size: 35,
          ),
        ),
      ],
    );
  }
}

class _UnblockButton extends StatelessWidget {
  _UnblockButton({required this.peer});
  final ChatUser peer;

  final _chatRoomViewModel = Get.find<ChatRoomViewModel>();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextButton(
          onPressed: () {
            _chatRoomViewModel.toggleBlockPeer(
                currentUserId: FirebaseAuth.instance.currentUser!.uid,
                peerId: peer.id);
          },
          child: const Text(
            "Unblock",
            style: TextStyle(fontSize: 16),
          ),
        ),
      )
    ]);
  }
}
