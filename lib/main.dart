import 'dart:async';
import 'package:chat_app/service/notification_service.dart';
import 'package:chat_app/utils/app_constant.dart';
import 'package:chat_app/utils/app_controller.dart';
import 'package:chat_app/utils/app_global.dart';
import 'package:chat_app/utils/app_page.dart';
import 'package:chat_app/utils/app_route.dart';
import 'package:chat_app/utils/app_util.dart';
import 'package:chat_app/view/theme/app_theme.dart';
import 'package:chat_app/view/widgets/custom_error.dart';
import 'package:chat_app/viewmodel/theme_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'service/analytics_service.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await GetStorage.init();
    _initDeviceToken();
    AppController.init();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

_initDeviceToken() async {
  final token = await NotificationService.getDeviceToken();
  AppGlobal().deviceToken = token;
  AppUtil.debugPrint("=======Token========");
  AppUtil.debugPrint(token);
  AppUtil.debugPrint("====================");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstant.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeViewModel.theme,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      initialRoute: AppRoute.rootPage,
      getPages: AppPage.pages,
      builder: (BuildContext context, Widget? widget) {
        _initCustomErrorWidget();
        return widget!;
      },
      navigatorObservers: [AnalyticsService().getAnalyticsObserver()],
    );
  }

  _initCustomErrorWidget() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return CustomError(errorDetails: errorDetails);
    };
  }
}
