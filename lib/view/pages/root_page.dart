import 'dart:convert';

import 'package:chat_app/view/pages/authentication/login_page.dart';
import 'package:chat_app/view/pages/chat/chat_page.dart';
import 'package:chat_app/viewmodel/chat_user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/core/services/notification_service.dart';
import 'package:chat_app/core/utils/app_global.dart';
import 'package:chat_app/core/router/app_route.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/core/utils/firebase_constant.dart';
import 'package:chat_app/core/utils/app_lifecycle_tracker.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  final chatUserViewModel = Get.find<ChatUserViewModel>();

  @override
  void initState() {
    super.initState();
    //====== init app lifecycle state =====
    WidgetsBinding.instance.addObserver(this);
    //==== end init app lifecycle state =========
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenBackgroundMessage();
      _listenMessageTerminated();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _checkAppState(AppGlobal.instance.appState ?? AppState.opened);
  }

  _checkAppState(AppState state) {
    if (state == AppState.opened || state == AppState.resumed) {
      chatUserViewModel.updateUserOnlineStatus(UserOnlineStatus.online);
    } else {
      chatUserViewModel.updateUserOnlineStatus(UserOnlineStatus.offline);
    }
  }

  _listenBackgroundMessage() async {
    NotificationService.onMessageOpenedApp().listen((message) async {
      await _onHandleMessage(message);
    });
  }

  _listenMessageTerminated() async {
    final RemoteMessage? message =
        await NotificationService.getInitialMessage();
    if (!AppUtil.checkIsNull(message)) {
      await _onHandleMessage(message);
    }
  }

  _onHandleMessage(RemoteMessage? message) async {
    if (message!.data[NotificationConstant.type] == NotificationConstant.chat) {
      var userFrom = ChatUser.fromJson(
          jsonDecode(message.data[NotificationConstant.userFrom]));
      await _navigateToChatRoom(peer: userFrom);
    }
  }

  _navigateToChatRoom({required ChatUser peer}) async {
    Get.toNamed(
      AppRoute.chatRoomPage,
      arguments: {"peer": peer, "fromRoute": AppRoute.chatPage},
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          _checkAppState(AppGlobal.instance.appState ?? AppState.opened);
          return ChatPage();
        } else {
          return const LoginPage();
        }
      }),
    );
  }
}
