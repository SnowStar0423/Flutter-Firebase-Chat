import 'dart:async';

import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/recent_user_chat.dart';
import 'package:chat_app/core/services/chat_service.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:chat_app/model/recent_chat.dart';
import 'package:chat_app/core/services/user_service.dart';

class ChatViewModel extends GetxController {
  ChatViewModel(
      {required this.firebaseAuth,
      required this.chatService,
      required this.userService});

  final FirebaseAuth firebaseAuth;
  final ChatService chatService;
  final UserService userService;
  RxList<RecentUserChat> recentUserChats = <RecentUserChat>[].obs;
  StreamSubscription? _loadRecentChatsListener;

  @override
  onInit() {
    super.onInit();
    loadRecentUserChats();
  }

  @override
  onClose() {
    _loadRecentChatsListener?.cancel();
  }

  loadRecentUserChats() async {
    try {
      _loadRecentChatsListener = chatService
          .loadRecentChats(
              currentUserId: firebaseAuth.currentUser!.uid, limit: 10)
          .listen((event) async {
        if (event.docs.isEmpty) return;
        List<String> listIdTo = [];
        List<RecentChat> recentChats = [];
        List<ChatUser> recentUsers = [];
        List<RecentUserChat> tempRecentUserChats = [];
        for (int i = 0; i < event.docs.length; i++) {
          recentChats.add(RecentChat.fromJson(event.docs.elementAt(i).data()));
          listIdTo.add(recentChats[i].idTo);
        }
        recentUsers = await _getRecentUsers(listIdTo);
        for (int i = 0; i < recentChats.length; i++) {
          ChatUser? user = recentUsers
              .firstWhere((element) => element.id == recentChats[i].idTo);
          tempRecentUserChats
              .add(RecentUserChat(recentChat: recentChats[i], chatUser: user));
        }
        recentUserChats.value = tempRecentUserChats;
      });
    } catch (e) {
      AppUtil.debugPrint(e.toString());
    }
  }

  Future<List<ChatUser>> _getRecentUsers(List<String> ids) async {
    try {
      final querySnap = await userService.getUsersByIds(ids: ids);
      List<ChatUser> users =
          querySnap.docs.map((e) => ChatUser.fromJson(e.data())).toList();
      return users;
    } catch (e) {
      throw Exception(e);
    }
  }

  clearRecentUserChats() {
    recentUserChats.value = [];
  }
}
