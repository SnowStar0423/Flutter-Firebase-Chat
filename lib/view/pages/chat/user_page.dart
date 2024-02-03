import 'dart:async';
import 'package:chat_app/view/widgets/chat_user_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/core/router/app_route.dart';
import 'package:chat_app/viewmodel/chat_user_view_model.dart';
import 'package:chat_app/view/widgets/round_textbox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ChatUserViewModel _userViewModel = Get.find<ChatUserViewModel>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _userViewModel.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody()),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            snap: false,
            floating: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 60.0,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding: EdgeInsets.zero,
              title: _buildHeader(),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          _buildUserList(),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
        ],
      ),
    );
  }

  _buildUserList() {
    return Obx(
      () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final user = _userViewModel.users[index];
            return ChatUserItem(
              user: user,
              onTap: () {
                Get.toNamed(AppRoute.chatRoomPage,
                    arguments: {"peer": user, "fromRoute": AppRoute.userPage});
              },
            );
          },
          childCount: _userViewModel.users.length,
        ),
      ),
    );
  }

  _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RoundTextBox(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ],
    );
  }

  _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _userViewModel.getUsers(searchText: text);
    });
  }
}
