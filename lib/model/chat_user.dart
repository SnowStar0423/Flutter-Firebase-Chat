import 'package:equatable/equatable.dart';

class ChatUser extends Equatable {
  final String id;
  final String displayName;
  final String? photoUrl;
  final String? phoneNumber;

  const ChatUser({
    required this.id,
    required this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [id, photoUrl, displayName, phoneNumber];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'phoneNumber': phoneNumber
    };
  }

  factory ChatUser.fromJson(Map<String, dynamic> map) {
    return ChatUser(
        id: (map['id']),
        photoUrl: (map['photoUrl']),
        displayName: (map['displayName']),
        phoneNumber: (map['phoneNumber']));
  }
}
