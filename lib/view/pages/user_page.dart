import 'dart:async';
import 'package:chat_app/view/widgets/chat_user_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_route.dart';
import '../../viewmodel/user_view_model.dart';
import '../widgets/round_textbox.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserViewModel _userViewModel = Get.find<UserViewModel>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel.getUsers();
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 60, 15, 5),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(
            height: 15,
          ),
          _buildChatList(),
        ],
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
            onChanged: _onSearchChanged,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
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

  _buildChatList() {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          final user = _userViewModel.users[index];
          return ChatUserItem(
            user: user,
            onTap: () {
              Get.toNamed(AppRoute.chatRoomPage, arguments: {"peer": user});
            },
          );
        }),
        itemCount: _userViewModel.users.length,
      ),
    );
  }
}
