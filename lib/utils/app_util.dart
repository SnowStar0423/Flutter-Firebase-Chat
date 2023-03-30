import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class AppUtil {
  static void debugPrint(var value) {
    if (kDebugMode) print(value);
  }

  static bool checkIsNull(value) {
    return [null, "null", ""].contains(value);
  }

  static showSnackBar(String message) {
    BuildContext context = Get.context!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static formatTimeAgo(DateTime dt) {
    return timeago.format(dt, allowFromNow: true, locale: 'en_short');
  }
}
