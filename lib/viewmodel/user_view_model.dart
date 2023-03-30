import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:get/get.dart';

class UserViewModel extends GetxController {
  UserViewModel({required this.userService});
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
}
