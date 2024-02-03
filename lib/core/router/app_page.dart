import 'package:chat_app/view/pages/authentication/forgot_password_page.dart';
import 'package:chat_app/view/pages/authentication/login_page.dart';
import 'package:chat_app/view/pages/authentication/register_page.dart';
import 'package:chat_app/view/pages/chat/chat_page.dart';
import 'package:chat_app/view/pages/chat/chat_room_page.dart';
import 'package:chat_app/view/pages/chat/user_page.dart';
import 'package:chat_app/view/pages/root_page.dart';
import 'package:chat_app/view/pages/setting/change_theme_page.dart';
import 'package:chat_app/view/pages/setting/edit_profile_page.dart';
import 'package:chat_app/view/pages/setting/setting_page.dart';
import 'package:get/get.dart';

import 'package:chat_app/core/router/app_route.dart';

class AppPage {
  AppPage._();
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
