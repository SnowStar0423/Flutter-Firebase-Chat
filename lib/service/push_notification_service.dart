import 'dart:convert';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/utils/firebase_constant.dart';
import 'package:get/get.dart';

class PushNotificationService {
  final _connection = GetConnect();

  pushNotification(
      {required ChatUser currentUser,
      required ChatUser peer,
      required String message}) async {
    final body = {
      "to": peer.deviceToken,
      "notification": {
        "title": currentUser.displayName,
        "body": message,
      },
      "data": {
        "idFrom": currentUser.id,
        "idTo": peer.id,
        "message": message,
      },
      "apns": {
        "payload": {
          "aps": {
            "sound": 'default',
          }
        }
      }
    };
    final header = {"Authorization": FireStoreConstant.pushServerKey};
    final res = await _connection.post(
      FireStoreConstant.pushNotificationURL,
      jsonEncode(body),
      headers: header,
    );
    return res;
  }
}
