import 'package:badges/badges.dart' as badges;
import 'package:chat_app/model/recent_user_chat.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import 'package:chat_app/core/style/app_color.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/notify_box.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(
      {super.key,
      required this.recentUserChat,
      this.onTap,
      this.isNotified = true,
      this.notifiedNumber = 0,
      this.profileSize = 50});
  final RecentUserChat recentUserChat;
  final bool isNotified;
  final GestureTapCallback? onTap;
  final double profileSize;
  final int notifiedNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppUtil.checkIsNull(recentUserChat.chatUser.photoUrl)
                    ? RandomAvatar(recentUserChat.chatUser.id,
                        trBackground: true,
                        width: profileSize,
                        height: profileSize)
                    : CustomImage(
                        recentUserChat.chatUser.photoUrl!,
                        imageType: ImageType.network,
                        width: profileSize,
                        height: profileSize,
                        radius: profileSize,
                      ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            recentUserChat.chatUser.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Visibility(
                          visible: recentUserChat.recentChat.isUnread,
                          child: const badges.Badge(
                            badgeStyle:
                                badges.BadgeStyle(badgeColor: AppColor.primary),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          AppUtil.formatTimeAgo(
                            DateTime.parse(recentUserChat.recentChat.timestamp),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            recentUserChat.recentChat.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        if (isNotified)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: NotifyBox(
                              number: notifiedNumber,
                              boxSize: 17,
                            ),
                          )
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
