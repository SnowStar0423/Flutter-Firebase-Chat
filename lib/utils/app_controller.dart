import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/viewmodel/auth_view_model.dart';
import 'package:chat_app/viewmodel/chat_room_view_model.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:chat_app/viewmodel/theme_view_model.dart';
import 'package:chat_app/viewmodel/user_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AppController {
  static Future init() async {
    Get.lazyPut(
        () => AuthViewModel(
            firebaseAuth: FirebaseAuth.instance,
            userService:
                UserService(firebaseFirestore: FirebaseFirestore.instance)),
        fenix: true);
    Get.lazyPut(
        () => ChatRoomViewModel(
            chatService:
                ChatService(firebaseFirestore: FirebaseFirestore.instance)),
        fenix: true);
    Get.lazyPut(
        () => UserViewModel(
            userService:
                UserService(firebaseFirestore: FirebaseFirestore.instance)),
        fenix: true);
    Get.lazyPut(
        () => ChatViewModel(
            chatService:
                ChatService(firebaseFirestore: FirebaseFirestore.instance)),
        fenix: true);
    Get.lazyPut(() => ThemeViewModel(), fenix: true);
  }
}
