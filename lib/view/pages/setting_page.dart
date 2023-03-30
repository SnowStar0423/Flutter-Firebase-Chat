import 'package:chat_app/utils/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../utils/app_constant.dart';
import '../../utils/app_util.dart';
import '../../viewmodel/auth_view_model.dart';
import '../theme/app_color.dart';
import '../widgets/custom_image.dart';
import '../widgets/settting_item.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});
  final AuthViewModel _authViewModel = Get.find();

  final _firebaseInstance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Setting"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppUtil.checkIsNull(FirebaseAuth.instance.currentUser!.photoURL)
                ? randomAvatar(FirebaseAuth.instance.currentUser!.uid,
                    trBackground: true, width: 70, height: 70)
                : CustomImage(
                    FirebaseAuth.instance.currentUser!.photoURL!,
                    imageType: ImageType.network,
                    width: 70,
                    height: 70,
                    radius: 100,
                  )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          _firebaseInstance.currentUser?.displayName ?? "N/A",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          _firebaseInstance.currentUser?.email ?? "N/A",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget _buildBody(context) {
    return ListView(
      children: [
        _buildProfile(),
        _buildSettingList(context),
      ],
    );
  }

  Widget _buildSettingList(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 20, bottom: 10),
      child: Column(
        children: [
          SettingItem(
            title: "Theme Mode",
            leadingIcon: Icons.dark_mode_rounded,
            leadingIconColor: AppColor.purple,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              Get.toNamed(AppRoute.changeThemePage);
            },
          ),
          const SizedBox(height: 10),
          const SettingItem(
            title: "Version",
            leadingIcon: Icons.system_update,
            leadingIconColor: AppColor.labelColor,
            trailing: Text(
              AppConstant.appVersion,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: "Logout",
            leadingIcon: Icons.logout,
            leadingIconColor: AppColor.red,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              Get.until((route) => route.isFirst);
              _authViewModel.signOut();
            },
          ),
        ],
      ),
    );
  }
}
