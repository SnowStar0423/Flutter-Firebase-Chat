import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/chat_service.dart';
import 'package:chat_app/core/services/report_service.dart';
import 'package:chat_app/core/services/user_service.dart';
import 'package:chat_app/viewmodel/auth_view_model.dart';
import 'package:chat_app/viewmodel/chat_room_view_model.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:chat_app/viewmodel/locale_view_model.dart';
import 'package:chat_app/viewmodel/profile_view_model.dart';
import 'package:chat_app/viewmodel/theme_view_model.dart';
import 'package:chat_app/viewmodel/chat_user_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AppController {
  AppController._();
  static Future init() async {
    Get.lazyPut(
        () => AuthViewModel(
              authService: AuthService(firebaseAuth: FirebaseAuth.instance),
              userService:
                  UserService(firebaseFirestore: FirebaseFirestore.instance),
            ),
        fenix: true);
    Get.lazyPut(
        () => ChatRoomViewModel(
              chatService:
                  ChatService(firebaseFirestore: FirebaseFirestore.instance),
              reportService:
                  ReportService(firebaseFirestore: FirebaseFirestore.instance),
              userService:
                  UserService(firebaseFirestore: FirebaseFirestore.instance),
            ),
        fenix: true);
    Get.lazyPut(
        () => ChatUserViewModel(
            firebaseAuth: FirebaseAuth.instance,
            userService: UserService(
              firebaseFirestore: FirebaseFirestore.instance,
            )),
        fenix: true);
    Get.lazyPut(
        () => ChatViewModel(
              firebaseAuth: FirebaseAuth.instance,
              chatService: ChatService(
                firebaseFirestore: FirebaseFirestore.instance,
              ),
              userService:
                  UserService(firebaseFirestore: FirebaseFirestore.instance),
            ),
        fenix: true);
    Get.lazyPut(() => ThemeViewModel(), fenix: true);
    Get.lazyPut(
        () => ProfileViewModel(
              firebaseAuth: FirebaseAuth.instance,
              userService: UserService(
                firebaseFirestore: FirebaseFirestore.instance,
              ),
              firebaseFirestore: FirebaseFirestore.instance,
              reportService: ReportService(
                firebaseFirestore: FirebaseFirestore.instance,
              ),
            ),
        fenix: true);
    Get.lazyPut(() => LocaleViewModel(), fenix: true);
  }
}
