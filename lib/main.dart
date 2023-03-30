import 'package:chat_app/utils/app_controller.dart';
import 'package:chat_app/utils/app_page.dart';
import 'package:chat_app/utils/app_route.dart';
import 'package:chat_app/view/theme/app_theme.dart';
import 'package:chat_app/viewmodel/theme_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppController.init();
  runApp(const MyApp());
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
