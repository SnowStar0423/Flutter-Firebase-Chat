import 'package:chat_app/model/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../view/pages/app_lifecycle_tracker.dart';

/// singleton class accessible across the app
class AppGlobal {
  String? _deviceToken;
  AppState? appState;
  static final AppGlobal _instance = AppGlobal._internal();

  AppGlobal._internal();

  factory AppGlobal() {
    return _instance;
  }
  // ignore: unnecessary_getters_setters
  String? get deviceToken => _deviceToken;
  set deviceToken(String? token) => _deviceToken = token;

  ChatUser firebaseUserToChatUser(User firebaseUser) {
    return ChatUser(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName!,
      photoUrl: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
      deviceToken: deviceToken,
    );
  }
}
