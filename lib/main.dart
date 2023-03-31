import 'dart:io';

import 'package:chat_app/utils/app_controller.dart';
import 'package:chat_app/utils/app_page.dart';
import 'package:chat_app/utils/app_route.dart';
import 'package:chat_app/view/theme/app_theme.dart';
import 'package:chat_app/viewmodel/theme_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  _getDeviceToken();
  AppController.init();
  runApp(const MyApp());
}

_getDeviceToken() async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  if (Platform.isIOS) {
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  final token = await firebaseMessaging.getToken();
  debugPrint("=======Token========");
  debugPrint(token);
  debugPrint("===============");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeViewModel.theme,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      initialRoute: AppRoute.rootPage,
      getPages: AppPage.pages,
    );
  }
}
