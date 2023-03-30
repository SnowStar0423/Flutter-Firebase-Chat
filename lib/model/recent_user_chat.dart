import 'chat_user.dart';
import 'recent_chat.dart';

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
