import 'package:chat_app/view/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
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

  static showSnackBar(String message, {int duration = 2}) {
    BuildContext context = Get.context!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }

  static formatTimeAgo(DateTime dt) {
    return timeago.format(dt, allowFromNow: true, locale: 'en_short');
  }

  static Future<bool> showConfirmDialog(BuildContext context, String info,
      {okTitle = "Ok", cancelTitle = "Cancel"}) async {
    bool res = false;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(
          info,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(true);
              res = true;
            },
            child: Text(
              okTitle,
              style: const TextStyle(color: AppColor.actionColor),
            ),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            cancelTitle,
            style: const TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
    );
    return res;
  }
}
