import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/recent_user_chat.dart';
import 'package:chat_app/core/router/app_route.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/view/widgets/custom_box.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';

import 'package:chat_app/viewmodel/profile_view_model.dart';
import 'package:chat_app/view/widgets/chat_item.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/round_textbox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatelessWidget {
  final ChatViewModel _chatViewModel = Get.find();

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          expandedHeight: 110.0,
          flexibleSpace: const FlexibleSpaceBar(
            expandedTitleScale: 1,
            titlePadding: EdgeInsets.zero,
            title: _SearchBox(),
            background: _TitleWidget(),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        _buildChatList(),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
      ],
    );
  }

  _navigateToChatRoom({required ChatUser peer}) async {
    await Get.toNamed(
      AppRoute.chatRoomPage,
      arguments: {"peer": peer, "fromRoute": AppRoute.chatPage},
    );
  }

  _buildChatList() {
    return Obx(
      () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            RecentUserChat recentUserChat =
                _chatViewModel.recentUserChats[index];
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ChatItem(
                recentUserChat: recentUserChat,
                onTap: () {
                  _navigateToChatRoom(peer: recentUserChat.chatUser);
                },
              ),
            );
          },
          childCount: _chatViewModel.recentUserChats.length,
        ),
      ),
    );
  }

  // _buildNoData() {
  //   return const SliverToBoxAdapter(
  //     child: SizedBox(
  //       height: 50,
  //       child: Center(
  //         child: Text(
  //           "No Recent Chats",
  //           style: TextStyle(fontSize: 18),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: RoundTextBox(
        readOnly: true,
        onTap: () {
          Get.toNamed(AppRoute.userPage);
        },
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.chats,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoute.settingPage);
            },
            child: GetBuilder<ProfileViewModel>(
              builder: (controller) {
                return CustomBox(
                  padding: 1,
                  child: AppUtil.checkIsNull(
                          FirebaseAuth.instance.currentUser!.photoURL)
                      ? RandomAvatar(FirebaseAuth.instance.currentUser!.uid,
                          trBackground: true, width: 40, height: 40)
                      : CustomImage(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                          imageType: ImageType.network,
                          width: 40,
                          height: 40,
                          radius: 100,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
