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
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
      'type': type,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> map) => ChatMessage(
        idFrom: map['idFrom'],
        idTo: map['idTo'],
        timestamp: map['timestamp'],
        content: map['content'],
        type: map['type'],
      );
}
