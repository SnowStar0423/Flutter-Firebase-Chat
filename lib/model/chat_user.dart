import 'package:chat_app/core/utils/firebase_constant.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class ChatUser extends Equatable {
  late String id;
  late String displayName;
  String? displayNameLowerCase;
  String? photoUrl;
  String? phoneNumber;
  String? deviceToken;
  String? onlineStatus;

  ChatUser(
      {required this.id,
      this.displayName = "",
      this.displayNameLowerCase,
      this.photoUrl,
      this.phoneNumber,
      this.deviceToken,
      this.onlineStatus});

  @override
  List<Object?> get props => [
        id,
        photoUrl,
        displayName,
        displayNameLowerCase,
        phoneNumber,
        deviceToken,
        onlineStatus
      ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ChatUserConstant.id: id,
      ChatUserConstant.photoUrl: photoUrl,
      ChatUserConstant.displayName: displayName,
      ChatUserConstant.displayNameLowerCase: displayName.toLowerCase(),
      ChatUserConstant.phoneNumber: phoneNumber,
      ChatUserConstant.deviceToken: deviceToken,
      ChatUserConstant.onlineStatus: onlineStatus,
    };
  }

  factory ChatUser.fromFirebaseUser(User firebaseUser, String? deviceToken) {
    return ChatUser(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName!,
      photoUrl: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
      deviceToken: deviceToken,
    );
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
      onlineStatus: (map.containsKey(ChatUserConstant.onlineStatus)
          ? map[ChatUserConstant.onlineStatus]
          : UserOnlineStatus.offline),
    );
  }
}
