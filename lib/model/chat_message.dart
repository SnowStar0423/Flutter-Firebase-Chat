import '../utils/firestore_constant.dart';

class ChatMessageType {
  static const String text = "text";
  static const String image = "text";
}

class ChatMessage {
  late String idFrom;
  late String idTo;
  late String timestamp;
  late String content;
  late String type;
  ChatMessage({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ChatMessageConstant.idFrom: idFrom,
      ChatMessageConstant.idTo: idTo,
      ChatMessageConstant.timestamp: timestamp,
      ChatMessageConstant.content: content,
      ChatMessageConstant.type: type,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> map) => ChatMessage(
        idFrom: map[ChatMessageConstant.idFrom],
        idTo: map[ChatMessageConstant.idTo],
        timestamp: map[ChatMessageConstant.timestamp],
        content: map[ChatMessageConstant.content],
        type: map[ChatMessageConstant.type],
      );
}
