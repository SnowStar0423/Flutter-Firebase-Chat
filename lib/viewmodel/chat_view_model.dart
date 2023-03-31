import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/recent_user_chat.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/utils/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/recent_chat.dart';
import '../service/user_service.dart';

class ChatViewModel extends GetxController {
  final ChatService chatService;
  ChatViewModel({required this.chatService});
  RxList<RecentUserChat> recentUserChats = <RecentUserChat>[].obs;

  @override
  onInit() {
    super.onInit();
    loadRecentUserChats();
  }

  loadRecentUserChats() async {
    chatService
        .loadRecentChats(currentUserId: FirebaseAuth.instance.currentUser!.uid)
        .listen((event) async {
      clearRecentUserChats();
      AppUtil.debugPrint("event: ${event.docs.length}");
      AppUtil.debugPrint("recent1: ${recentUserChats.length}");
      List<String> listIdTo = [];
      List<RecentChat> recentChats = [];
      List<ChatUser> recentUsers = [];
      for (int i = 0; i < event.docs.length; i++) {
        recentChats.add(RecentChat.fromJson(event.docs.elementAt(i).data()));
        listIdTo.add(recentChats[i].idTo);
      }
      recentUsers = await _getRecentUsers(listIdTo);
      for (int i = 0; i < recentChats.length; i++) {
        var user = recentUsers
            .firstWhere((element) => element.id == recentChats[i].idTo);
        recentUserChats
            .add(RecentUserChat(recentChat: recentChats[i], chatUser: user));
      }

      AppUtil.debugPrint("recent2: ${recentUserChats.length}");
    });
  }

  Future<List<ChatUser>> _getRecentUsers(List<String> ids) async {
    final userService =
        UserService(firebaseFirestore: FirebaseFirestore.instance);
    final querySnap = await userService.getUsersByIds(ids: ids);
    List<ChatUser> users =
        querySnap.docs.map((e) => ChatUser.fromJson(e.data())).toList();
    return users;
  }

  clearRecentUserChats() {
    recentUserChats.value = [];
  }
}
