import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/recent_chat.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/push_notification_service.dart';
import 'package:chat_app/utils/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/chat_message.dart';

class ChatRoomViewModel extends GetxController {
  final ChatService chatService;
  ChatRoomViewModel({required this.chatService});
  final RxBool _sending = false.obs;
  final RxBool _loadingMessages = false.obs;
  String _message = "";
  DocumentSnapshot? lastdocumentSnapshot;
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;

  bool _moreMessagesAvailable = true;

  get message => _message;
  set message(ms) => _message = ms;

  set sending(bool value) => _sending.value = value;
  bool get sending => _sending.value;

  set loadingMessages(bool value) => _loadingMessages.value = value;
  bool get loadingMessages => _loadingMessages.value;

  clearChatMessages() {
    chatMessages.value = [];
  }

  updateSeenRecentChat(
      {required RecentChat recentChat,
      required String currentUserId,
      required String peerId}) async {
    recentChat.isUnread = false;
    chatService.updateSeenRecentChat(
        recentChat: recentChat, currentUserId: currentUserId, peerId: peerId);
  }

  _assignLastDocument(QueryDocumentSnapshot lastDocument) {
    lastdocumentSnapshot = lastDocument;
  }

  loadMessages(String groupChatId) {
    if (!_moreMessagesAvailable || loadingMessages) return;
    loadingMessages = true;
    if (lastdocumentSnapshot == null) {
      chatService.loadChatMessages(groupChatId: groupChatId).listen((event) {
        chatMessages.value =
            event.docs.map((e) => ChatMessage.fromJson(e.data())).toList();
        if (event.docs.isNotEmpty) {
          _assignLastDocument(event.docs[event.docs.length - 1]);
        }
      });
    } else {
      chatService
          .loadMoreChatMessages(
              groupChatId: groupChatId,
              lastdocumentSnapshot: lastdocumentSnapshot!)
          .listen((event) {
        if (event.docs.isNotEmpty) {
          chatMessages.addAll(
              event.docs.map((e) => ChatMessage.fromJson(e.data())).toList());
          _assignLastDocument(event.docs[event.docs.length - 1]);
        } else {
          _moreMessagesAvailable = false;
        }
      });
    }
    loadingMessages = false;
  }

  String generateGroupChatId(String fromId, String toID) {
    if (fromId.compareTo(toID) > 0) {
      return "$fromId-$toID";
    }
    return "$toID-$fromId";
  }

  Future<bool> sendChatMessage(
      {required String content,
      required String type,
      required String groupChatId,
      required String currentUserId,
      required String peerId}) async {
    if (content.isEmpty) return false;
    sending = true;
    try {
      await chatService.sendChatMessage(
          content: content,
          type: type,
          groupChatId: groupChatId,
          currentUserId: currentUserId,
          peerId: peerId);
      chatService.addRecentChat(
          content: content, currentUserId: currentUserId, peerId: peerId);
      sending = false;
      return true;
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      return false;
    } finally {
      sending = false;
    }
  }

  Future<bool> sendChatMessageWithPushNotification(
      {required String content,
      required String type,
      required String groupChatId,
      required ChatUser currentUser,
      required ChatUser peer}) async {
    if (content.isEmpty) return false;
    sending = true;
    try {
      await chatService.sendChatMessage(
          content: content,
          type: type,
          groupChatId: groupChatId,
          currentUserId: currentUser.id,
          peerId: peer.id);
      chatService.addRecentChat(
          content: content, currentUserId: currentUser.id, peerId: peer.id);
      if (!AppUtil.checkIsNull(peer.deviceToken)) {
        PushNotificationService().pushNotification(
            currentUser: currentUser, peer: peer, message: content);
      }
      sending = false;
      return true;
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      return false;
    } finally {
      sending = false;
    }
  }
}
