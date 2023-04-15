import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/push_notification_service.dart';
import 'package:chat_app/service/report_service.dart';
import 'package:chat_app/utils/app_message.dart';
import 'package:chat_app/utils/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/chat_message.dart';

class ChatRoomViewModel extends GetxController {
  final ChatService chatService;
  final ReportService reportService;
  ChatRoomViewModel({required this.chatService, required this.reportService});
  final RxBool _sending = false.obs;
  final RxBool _loadingMessages = false.obs;
  final RxBool _isBlockedPeer = false.obs;
  final RxBool _isBlocked = false.obs;
  String _message = "";
  DocumentSnapshot? lastdocumentSnapshot;
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;

  bool _moreMessagesAvailable = true;

  bool get isBlockedPeer => _isBlockedPeer.value;
  set isBlockedPeer(value) => _isBlockedPeer.value = value;
  bool get isBlocked => _isBlocked.value;
  set isBlocked(value) => _isBlocked.value = value;

  String get message => _message;
  set message(ms) => _message = ms;

  set sending(bool value) => _sending.value = value;
  bool get sending => _sending.value;

  set loadingMessages(bool value) => _loadingMessages.value = value;
  bool get loadingMessages => _loadingMessages.value;

  clearChatMessages() {
    chatMessages.value = [];
  }

  updateRecentChatSeen(
      {required String currentUserId,
      required String peerId,
      bool isSeen = true}) async {
    chatService.updateRecentChatSeen(
        currentUserId: currentUserId, peerId: peerId, isSeen: isSeen);
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
    if (content.trim().isEmpty) return false;
    sending = true;
    try {
      await chatService.sendChatMessage(
          content: content.trim(),
          type: type,
          groupChatId: groupChatId,
          currentUserId: currentUser.id,
          peerId: peer.id);
      chatService.addRecentChat(
          content: content.trim(),
          currentUserId: currentUser.id,
          peerId: peer.id);
      if (!AppUtil.checkIsNull(peer.deviceToken)) {
        PushNotificationService().pushNotification(
            currentUser: currentUser, peer: peer, message: content.trim());
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

  reportUser(
      {required String currentUserId,
      required String peerId,
      String content = ""}) async {
    reportService.reportUser(
      userId: currentUserId,
      reportedUserId: peerId,
      content: content,
    );
    message = AppMessage.messageAfterReport;
  }

  toggleBlockPeer(
      {required String currentUserId,
      required String peerId,
      String content = ""}) async {
    if (isBlockedPeer) {
      unBlockPeer(currentUserId: currentUserId, peerId: peerId);
      message = AppMessage.messageAfterUnblock;
    } else {
      blockPeer(currentUserId: currentUserId, peerId: peerId, content: content);
      message = AppMessage.messageAfterBlock;
    }
  }

  blockPeer(
      {required String currentUserId,
      required String peerId,
      String content = ""}) async {
    try {
      reportService.blockPeer(
        userId: currentUserId,
        peerId: peerId,
        content: content,
      );
      isBlockedPeer = true;
    } catch (e) {
      AppUtil.checkIsNull(e.toString());
    }
  }

  unBlockPeer(
      {required String currentUserId,
      required String peerId,
      String content = ""}) async {
    try {
      reportService.unblockPeer(
        userId: currentUserId,
        peerId: peerId,
      );
      isBlockedPeer = false;
    } catch (e) {
      AppUtil.checkIsNull(e.toString());
    }
  }

  checkIsBlockedPeer(
      {required String currentUserId, required String peerId}) async {
    try {
      isBlockedPeer = await reportService.checkIsBlockedPeer(
          userId: currentUserId, peerId: peerId);
    } catch (e) {
      AppUtil.checkIsNull(e.toString());
    }
  }

  checkIsBlocked(
      {required String currentUserId, required String peerId}) async {
    try {
      isBlocked = await reportService.checkIsBlocked(
          userId: currentUserId, peerId: peerId);
      AppUtil.checkIsNull("checkIsBlocked $isBlocked");
    } catch (e) {
      AppUtil.checkIsNull(e.toString());
    }
  }

  checkIsUserBlocked(
      {required String currentUserId, required String peerId}) async {
    try {
      reportService
          .checkIsUserBlocked(userId: currentUserId, peerId: peerId)
          .listen((event) {
        isBlocked = false;
        if (event.exists) {
          isBlocked = true;
        }
      });
      AppUtil.checkIsNull("checkIsBlocked $isBlocked");
    } catch (e) {
      AppUtil.checkIsNull(e.toString());
    }
  }
}
