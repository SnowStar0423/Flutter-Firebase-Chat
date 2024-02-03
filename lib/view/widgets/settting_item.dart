import 'package:flutter/material.dart';

import 'package:chat_app/core/style/app_color.dart';

class SettingItem extends StatelessWidget {
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final String title;
  final GestureTapCallback? onTap;
  final Widget? trailing;
  const SettingItem(
      {super.key,
      required this.title,
      this.onTap,
      this.leadingIcon,
      this.leadingIconColor = Colors.white,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: leadingIcon != null
              ? [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      leadingIcon,
                      size: 24,
                      color: leadingIconColor,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (trailing != null) trailing!
                ]
              : [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (trailing != null) trailing!
                ],
        ),
      ),
    );
  }
}
