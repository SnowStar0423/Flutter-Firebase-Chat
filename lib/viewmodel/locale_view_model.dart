import 'dart:ui';

import 'package:chat_app/core/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleViewModel extends GetxController {
  final GetStorage _box;
  LocaleViewModel() : _box = GetStorage() {
    _loadLocaleCode();
  }

  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale l) {
    if (l == locale) return;
    _locale = l;
    Get.updateLocale(l);
    _saveLocaleCode(l.languageCode);
  }

  void _saveLocaleCode(String code) async {
    _box.write(AppConstant.localeCode, code);
  }

  void _loadLocaleCode() {
    String? code = _box.read(AppConstant.localeCode);
    if (code != null) {
      _locale = Locale(code);
    }
  }
}
