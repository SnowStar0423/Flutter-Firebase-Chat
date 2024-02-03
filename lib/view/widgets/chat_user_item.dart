import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:chat_app/view/widgets/custom_image.dart';

class ChatUserItem extends StatelessWidget {
  const ChatUserItem(
      {super.key, required this.user, this.onTap, this.profileSize = 50});
  final ChatUser user;
  final GestureTapCallback? onTap;
  final double profileSize;

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
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            AppUtil.checkIsNull(user.photoUrl)
                ? RandomAvatar(user.id,
                    trBackground: true, width: profileSize, height: profileSize)
                : CustomImage(
                    user.photoUrl!,
                    imageType: ImageType.network,
                    width: profileSize,
                    height: profileSize,
                    radius: profileSize,
                  ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                user.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
