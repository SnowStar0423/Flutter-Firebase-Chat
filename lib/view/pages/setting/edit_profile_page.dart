import 'package:badges/badges.dart' as badges;
import 'package:chat_app/core/style/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';

import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/viewmodel/profile_view_model.dart';
import 'package:chat_app/view/widgets/custom_box.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    _profileViewModel.resetUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
          profileViewModel: _profileViewModel, nameController: _nameController),
      body: _buildBody(),
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
              _ProfileWidget(profileViewModel: _profileViewModel),
              const SizedBox(
                height: 25,
              ),
              _NameWidget(context: context, nameController: _nameController),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ignore: unused_element
class _NameWidget extends StatelessWidget {
  const _NameWidget({
    required this.context,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final BuildContext context;
  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return CustomBox(
      radius: 10,
      padding: 0,
      child: CustomTextField(
        hintText: AppLocalizations.of(context)!.name,
        controller: _nameController,
        leadingIcon: const Icon(
          Icons.person_outline,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required ProfileViewModel profileViewModel,
    required TextEditingController nameController,
  })  : _profileViewModel = profileViewModel,
        _nameController = nameController;

  final ProfileViewModel _profileViewModel;
  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(AppLocalizations.of(context)!.profile),
      actions: [
        TextButton(
          onPressed: () async {
            var res = await _profileViewModel.saveProfile(_nameController.text);
            if (res && context.mounted) {
              AppUtil.showSnackBar(
                AppLocalizations.of(context)!.updatedSuccessfully,
              );
            }
          },
          child: Obx(
            () => Text(
              AppLocalizations.of(context)!.save,
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

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _ProfileWidget extends StatelessWidget {
  const _ProfileWidget({
    required ProfileViewModel profileViewModel,
  }) : _profileViewModel = profileViewModel;

  final ProfileViewModel _profileViewModel;

  Widget _buildProfileImage() {
    return AppUtil.checkIsNull(_profileViewModel.selectedImage)
        ? _ProfileImageChecker(profileViewModel: _profileViewModel)
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              width: 80,
              height: 80,
              child: _profileViewModel.isUploadingImage.value
                  ? Image.file(
                      _profileViewModel.selectedImage!,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.2),
                      colorBlendMode: BlendMode.dstATop,
                    )
                  : Image.file(
                      _profileViewModel.selectedImage!,
                      fit: BoxFit.cover,
                    ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return CustomBox(
      radius: 15,
      padding: 20,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: screenSize.width,
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
            child: Text(
              AppLocalizations.of(context)!.setNewPhoto,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            _profileViewModel.getUserDisplayName(),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(
            width: screenSize.width,
          ),
          Text(
            _profileViewModel.getUserEmail(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _ProfileImageChecker extends StatelessWidget {
  const _ProfileImageChecker({
    required ProfileViewModel profileViewModel,
  }) : _profileViewModel = profileViewModel;

  final ProfileViewModel _profileViewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppUtil.checkIsNull(_profileViewModel.getUserPhotoUrl())
            ? RandomAvatar(FirebaseAuth.instance.currentUser!.uid,
                trBackground: true, width: 78, height: 78)
            : badges.Badge(
                onTap: () {
                  _profileViewModel.removeUserPhotoUrl();
                },
                badgeContent: const Icon(
                  Icons.close_outlined,
                  color: Colors.white,
                  size: 15,
                ),
                child: CustomImage(
                  _profileViewModel.getUserPhotoUrl()!,
                  imageType: ImageType.network,
                  width: 70,
                  height: 70,
                  radius: 100,
                ),
              )
      ],
    );
  }
}
