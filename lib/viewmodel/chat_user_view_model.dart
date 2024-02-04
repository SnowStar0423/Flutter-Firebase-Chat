import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/core/services/user_service.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatUserViewModel extends GetxController {
  ChatUserViewModel({required this.firebaseAuth, required this.userService});
  final FirebaseAuth firebaseAuth;
  final UserService userService;
  RxList<ChatUser> users = <ChatUser>[].obs;

  getUsers({String searchText = ''}) async {
    clearUser();
    final res = await userService.getUsers(searchText: searchText);
    for (var element in res.docs) {
      users.add(ChatUser.fromJson(element.data()));
    }
  }

  clearUser() {
    users.value = [];
  }

  updateUserOnlineStatus(String status) async {
    if (AppUtil.checkIsNull(firebaseAuth.currentUser) ||
        !await userService.checkUserExist(firebaseAuth.currentUser!.uid)) {
      return;
    }
    await userService.updateUserOnlineStatus(
        firebaseAuth.currentUser!.uid, status);
  }
}
