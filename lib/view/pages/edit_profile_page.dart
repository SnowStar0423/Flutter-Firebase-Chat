import 'package:chat_app/view/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../utils/app_util.dart';
import '../../viewmodel/profile_view_model.dart';
import '../widgets/custom_box.dart';
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
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(
        "Profile",
      ),
      actions: [
        TextButton(
          onPressed: () async {
            var res = await _profileViewModel.saveProfile(_nameController.text);
            if (res) {
              AppUtil.showSnackBar("Updated successfully.");
            }
          },
          child: Obx(
            () => Text(
              "Save",
              style: TextStyle(
                color:
                    _profileViewModel.saving ? AppColor.darker : AppColor.white,
                fontSize: 17,
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildBody() {
    return GetBuilder<ProfileViewModel>(builder: (controller) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 30,
              ),
              _buildProfileBlock(),
              const SizedBox(
                height: 25,
              ),
              // _buildEmailBlock(),
              // const SizedBox(
              //   height: 15,
              // ),
              _buildNameBlock(),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget _buildEmailBlock() {
  //   return CustomBox(
  //     radius: 10,
  //     padding: 0,
  //     child: CustomTextField(
  //       hintText: "name",
  //       controller: _emailController,
  //       readOnly: true,
  //       keyboardType: TextInputType.emailAddress,
  //       leadingIcon: const Icon(
  //         Icons.email_outlined,
  //         color: Colors.grey,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildNameBlock() {
    return CustomBox(
      radius: 10,
      padding: 0,
      child: CustomTextField(
        hintText: "name",
        controller: _nameController,
        leadingIcon: const Icon(
          Icons.person_outline,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _checkProfileImage() {
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

  Widget _buildProfileImage() {
    return _profileViewModel.getSelectedImage() == null
        ? _checkProfileImage()
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
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
    return CustomBox(
      radius: 15,
      padding: 20,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          GestureDetector(
            onTap: () {
              _profileViewModel.browseImage();
            },
            child: _buildProfileImage(),
          ),
          TextButton(
            onPressed: () {
              _profileViewModel.browseImage();
            },
            child: const Text(
              "set new photo",
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            _profileViewModel.getUserDisplayName(),
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          Text(
            _profileViewModel.getUserEmail(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
