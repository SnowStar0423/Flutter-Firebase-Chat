import 'dart:async';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/core/services/notification_service.dart';
import 'package:chat_app/core/utils/app_constant.dart';
import 'package:chat_app/core/utils/app_controller.dart';
import 'package:chat_app/core/utils/app_global.dart';
import 'package:chat_app/core/router/app_page.dart';
import 'package:chat_app/core/router/app_route.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/core/style/app_theme.dart';
import 'package:chat_app/view/widgets/custom_error.dart';
import 'package:chat_app/viewmodel/locale_view_model.dart';
import 'package:chat_app/viewmodel/theme_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chat_app/core/services/analytics_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:chat_app/core/utils/app_lifecycle_tracker.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await GetStorage.init();
    _initDeviceToken();
    await AppController.init();
    if (!kIsWeb) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
    runApp(AppLifecycleTracker(
      child: const MyApp(),
      didChangeAppState: (state) => AppGlobal.instance.appState = state,
    ));
  }, (error, stack) {
    AppUtil.debugPrint(error);
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}

_initDeviceToken() async {
  final token = await NotificationService.getDeviceToken();
  AppGlobal.instance.deviceToken = token;
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Get.find<LocaleViewModel>().locale,
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
