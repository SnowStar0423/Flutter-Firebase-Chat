import 'package:chat_app/view/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:chat_app/view/widgets/term_service.dart';
import 'package:chat_app/utils/app_constant.dart';

/// AppUtil provides helper methods
class AppUtil {
  /// prints only in debug mode
  static void debugPrint(var value) {
    if (kDebugMode) print(value);
  }

  /// checks if [value] is null
  static bool checkIsNull(value) {
    return [null, "null", ""].contains(value);
  }

  /// shows snackbar with [message]
  static void showSnackBar(String message, {int duration = 2}) {
    BuildContext context = Get.context!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }

  /// format DateTime [dt] to string time ago
  static String formatTimeAgo(DateTime dt) {
    return timeago.format(dt, allowFromNow: true, locale: 'en_short');
  }

  /// show custom confirm dialog with [message]
  static Future<bool> showConfirmDialog(BuildContext context, String message,
      {okTitle = "Ok", cancelTitle = "Cancel"}) async {
    bool res = false;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(
          message,
          style: Theme.of(context).textTheme.titleMedium,
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

  /// show options for a user to perform actions [report, block] on another user
  static Future<void> showUserActionsDialog(BuildContext context,
      {String report = "Report",
      required Function() onRepot,
      String block = "Block",
      required Function() onBlock,
      String cancel = "Cancel",
      required Function() onCancel}) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: onRepot,
            child: Text(
              report,
              style: const TextStyle(color: AppColor.actionColor),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: onBlock,
            child: Text(
              block,
              style: const TextStyle(color: AppColor.actionColor),
            ),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: onCancel,
          child: Text(
            cancel,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  /// show app's terms and service agreement to a user who is required to accept before using the app
  static Future<void> showTermsService() async {
    var box = GetStorage();
    final val = box.read(AppConstant.termsService);
    if (AppUtil.checkIsNull(val)) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TermService(
            onAccept: () {
              box.write(AppConstant.termsService, true);
              Get.back();
            },
          );
        },
      );
    }
  }
}
