// ignore_for_file: public_member_api_docs, sort_constructors_first
class RecentChat {
  late String idFrom;
  late String idTo;
  late String timestamp;
  late String content;
  late bool isUnread;

  RecentChat(
      {required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.content,
      this.isUnread = true});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
      'isUnread': isUnread,
    };
  }

  factory RecentChat.fromJson(Map<String, dynamic> map) => RecentChat(
        idFrom: map['idFrom'],
        idTo: map['idTo'],
        timestamp: map['timestamp'],
        content: map['content'],
        isUnread: map['isUnread'],
      );
}
