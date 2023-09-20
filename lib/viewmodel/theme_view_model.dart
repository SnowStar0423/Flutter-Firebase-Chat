import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chat_app/core/utils/app_constant.dart';

class ThemeViewModel extends GetxController {
  static final _box = GetStorage();
  static final RxBool _isDarkModeDefaultSystem = _loadThemeModeSystem().obs;
  static final RxBool _isDarkMode = _loadThemeMode().obs;

  static ThemeMode get theme =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  static bool _loadThemeMode() {
    if (_isDarkModeDefaultSystem.value) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _box.read(AppConstant.themeMode) ?? false;
  }

  static _saveThemeMode(bool isDark) async {
    _box.write(AppConstant.themeMode, isDark);
  }

  static _saveThemeModeSystem(bool isDefault) {
    _box.write(AppConstant.themeModeDefaultSystem, isDefault);
  }

  static bool _loadThemeModeSystem() {
    return _box.read(AppConstant.themeModeDefaultSystem) ?? false;
  }

  _triggerDarkMode() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    _saveThemeMode(isDarkMode);
    _saveThemeModeSystem(isDarkModeDefaultSystem);
  }

  switchThemeMode() async {
    isDarkMode = !isDarkMode;
    _triggerDarkMode();
  }

  setDarkMode(bool value) {
    if (isDarkMode == value) return;
    // set system to false when selecting any option
    isDarkModeDefaultSystem = false;
    //====
    isDarkMode = value;
    _triggerDarkMode();
  }

  setDarkModeDefaultSystem(bool isDefault) {
    isDarkModeDefaultSystem = isDefault;
    if (isDarkModeDefaultSystem) {
      isDarkMode =
          SchedulerBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
    }
    _triggerDarkMode();
  }

  bool get isDarkMode => _isDarkMode.value;
  set isDarkMode(bool value) => _isDarkMode.value = value;

  bool get isDarkModeDefaultSystem => _isDarkModeDefaultSystem.value;
  set isDarkModeDefaultSystem(bool value) =>
      _isDarkModeDefaultSystem.value = value;
}
