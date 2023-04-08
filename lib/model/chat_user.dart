import 'package:chat_app/utils/firebase_constant.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ChatUser extends Equatable {
  late String id;
  late String displayName;
  String? displayNameLowerCase;
  String? photoUrl;
  String? phoneNumber;
  String? deviceToken;

  ChatUser(
      {required this.id,
      this.displayName = "",
      this.displayNameLowerCase,
      this.photoUrl,
      this.phoneNumber,
      this.deviceToken});

  @override
  List<Object?> get props =>
      [id, photoUrl, displayName, phoneNumber, deviceToken];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ChatUserConstant.id: id,
      ChatUserConstant.photoUrl: photoUrl,
      ChatUserConstant.displayName: displayName,
      ChatUserConstant.displayNameLowerCase: displayName.toLowerCase(),
      ChatUserConstant.phoneNumber: phoneNumber,
      ChatUserConstant.deviceToken: deviceToken
    };
  }

  factory ChatUser.fromJson(Map<String, dynamic> map) {
    return ChatUser(
      id: (map[ChatUserConstant.id]),
      photoUrl: (map[ChatUserConstant.photoUrl]),
      displayName: (map[ChatUserConstant.displayName]),
      displayNameLowerCase:
          (map.containsKey(ChatUserConstant.displayNameLowerCase)
              ? map[ChatUserConstant.displayNameLowerCase]
              : map[ChatUserConstant.displayName].toString().toLowerCase()),
      phoneNumber: (map[ChatUserConstant.phoneNumber]),
      deviceToken: (map.containsKey(ChatUserConstant.deviceToken)
          ? map[ChatUserConstant.deviceToken]
          : null),
    );
  }
}
