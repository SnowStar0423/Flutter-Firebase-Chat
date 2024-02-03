import 'dart:ui';

import 'package:get/get.dart';

class LocaleViewModel extends GetxController {
  Locale? _locale;

  Locale? get locale => _locale;

  void set(Locale locale) {
    _locale = locale;
    update();
  }
}
