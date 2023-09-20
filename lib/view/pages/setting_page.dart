import 'package:chat_app/core/utils/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';

import 'package:chat_app/core/utils/app_constant.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/viewmodel/auth_view_model.dart';
import 'package:chat_app/viewmodel/profile_view_model.dart';
import 'package:chat_app/view/theme/app_color.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/custom_input_dialog.dart';
import 'package:chat_app/view/widgets/settting_item.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});
  final AuthViewModel _authViewModel = Get.find();
  final ProfileViewModel _profileViewModel = Get.find();

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

  Widget _buildBody(context) {
    return ListView(
      children: [
        _buildProfile(),
        _buildSettingList(context),
      ],
    );
  }

  Widget _buildProfile() {
    return GetBuilder<ProfileViewModel>(
      builder: (controller) => Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          _buildProfileImage(),
          const SizedBox(
            height: 10,
          ),
          Text(
            _profileViewModel.getUserDisplayName(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            _profileViewModel.getUserEmail(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppUtil.checkIsNull(FirebaseAuth.instance.currentUser!.photoURL)
            ? RandomAvatar(FirebaseAuth.instance.currentUser!.uid,
                trBackground: true, width: 70, height: 70)
            : CustomImage(
                FirebaseAuth.instance.currentUser!.photoURL!,
                imageType: ImageType.network,
                width: 70,
                height: 70,
                radius: 100,
              )
      ],
    );
  }

  Widget _buildSettingList(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 20, bottom: 10),
      child: Column(
        children: [
          SettingItem(
            title: "Edit Profile",
            leadingIcon: Icons.person,
            leadingIconColor: AppColor.green,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              Get.toNamed(AppRoute.editProfilePage);
            },
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: "Change Theme",
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
          SettingItem(
            title: "Feedback",
            leadingIcon: Icons.rate_review,
            leadingIconColor: AppColor.blue,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              _showDialog(context);
            },
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: "Share",
            leadingIcon: Icons.share_outlined,
            leadingIconColor: AppColor.yellow,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              Share.share(
                AppConstant.storesLink,
                subject: AppConstant.appName,
              );
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

  _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomInputDialog(
          title: 'Feedback',
          hint: 'Please write your feedback',
          ok: 'Submit',
        );
      },
    ).then((value) {
      if (value != null) {
        AppUtil.debugPrint(value);
        _profileViewModel.sendFeedback(value);
        AppUtil.showSnackBar("Thank you for your feedback.");
      }
    });
  }
}
