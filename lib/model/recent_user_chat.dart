import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/recent_chat.dart';

class RecentUserChat {
  late RecentChat recentChat;
  late ChatUser chatUser;

  RecentUserChat({required this.recentChat, required this.chatUser});

  factory RecentUserChat.fromJson(Map<String, dynamic> recentChatJson,
          Map<String, dynamic> userChatJson) =>
      RecentUserChat(
          recentChat: RecentChat.fromJson(recentChatJson),
          chatUser: ChatUser.fromJson(userChatJson));
}
