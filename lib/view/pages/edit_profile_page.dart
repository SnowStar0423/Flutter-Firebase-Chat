import 'package:chat_app/view/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../utils/app_util.dart';
import '../../viewmodel/profile_view_model.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final ProfileViewModel _profileViewModel = Get.find();

  @override
  initState() {
    super.initState();
    _nameController.text = _profileViewModel.getUserDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: const Text(
              "Profile",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _profileViewModel.saveProfile(_nameController.text);
                  Get.back();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: AppColor.white),
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: buildBody(),
          )
        ],
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          _buildProfileBlock(),
          const SizedBox(height: 30),
          _buildNameBlock(),
          const Divider(
            color: Colors.grey,
            height: 10,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _getProfileImage() {
    return Row(
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
    );
  }

  Widget _buildNameBlock() {
    return CustomTextField(
      controller: _nameController,
      leadingIcon: const Icon(
        Icons.person_outline,
        color: Colors.grey,
      ),
      hintText: "Name",
    );
  }

  Widget _buildProfileImage() {
    return _profileViewModel.getSelectedImage() == null
        ? _getProfileImage()
        : ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: 80,
              height: 80,
              child: _profileViewModel.isUploadingImage.value
                  ? Image.file(
                      _profileViewModel.getSelectedImage()!,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.2),
                      colorBlendMode: BlendMode.dstATop,
                    )
                  : Image.file(
                      _profileViewModel.getSelectedImage()!,
                      fit: BoxFit.cover,
                    ),
            ),
          );
  }

  Widget _buildProfileBlock() {
    return GestureDetector(
      onTap: () {
        _profileViewModel.browseImage();
      },
      child: GetBuilder<ProfileViewModel>(
        builder: (controller) => _buildProfileImage(),
      ),
    );
  }
}
