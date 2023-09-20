import 'package:chat_app/view/pages/change_theme_page.dart';
import 'package:chat_app/view/pages/chat_page.dart';
import 'package:chat_app/view/pages/edit_profile_page.dart';
import 'package:chat_app/view/pages/forgot_password_page.dart';
import 'package:chat_app/view/pages/login_page.dart';
import 'package:chat_app/view/pages/register_page.dart';
import 'package:chat_app/view/pages/root_page.dart';
import 'package:chat_app/view/pages/setting_page.dart';
import 'package:chat_app/view/pages/user_page.dart';
import 'package:get/get.dart';

import 'package:chat_app/view/pages/chat_room_page.dart';
import 'package:chat_app/core/utils/app_route.dart';

class AppPage {
  static final List<GetPage> pages = [
    GetPage(name: AppRoute.rootPage, page: () => const RootPage()),
    GetPage(name: AppRoute.loginPage, page: () => const LoginPage()),
    GetPage(name: AppRoute.registerPage, page: () => const RegisterPage()),
    GetPage(name: AppRoute.chatPage, page: () => ChatPage()),
    GetPage(name: AppRoute.chatRoomPage, page: () => const ChatRoomPage()),
    GetPage(name: AppRoute.changeThemePage, page: () => ChangeThemePage()),
    GetPage(
      name: AppRoute.forgotPasswordPage,
      page: () => const ForgotPasswordPage(),
      fullscreenDialog: true,
      transition: Transition.fade,
    ),
    GetPage(
        name: AppRoute.editProfilePage, page: () => const EditProfilePage()),
    GetPage(
      name: AppRoute.settingPage,
      page: () => SettingPage(),
      fullscreenDialog: true,
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoute.userPage,
      page: () => const UserPage(),
      fullscreenDialog: true,
      transition: Transition.fade,
    ),
  ];
}
