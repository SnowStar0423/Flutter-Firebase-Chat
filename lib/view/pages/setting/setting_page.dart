import 'package:chat_app/core/router/app_route.dart';
import 'package:chat_app/model/locale_model.dart';
import 'package:chat_app/view/widgets/custom_box.dart';
import 'package:chat_app/viewmodel/locale_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';

import 'package:chat_app/core/utils/app_constant.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/viewmodel/auth_view_model.dart';
import 'package:chat_app/viewmodel/profile_view_model.dart';
import 'package:chat_app/core/style/app_color.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/custom_input_dialog.dart';
import 'package:chat_app/view/widgets/settting_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});
  final AuthViewModel _authViewModel = Get.find();
  final ProfileViewModel _profileViewModel = Get.find();
  final LocaleViewModel _localeViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return ListView(
      children: [
        _ProfileWidget(profileViewModel: _profileViewModel),
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
            title: AppLocalizations.of(context)!.editProfile,
            leadingIcon: Icons.person,
            leadingIconColor: Theme.of(context).iconTheme.color,
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
            title: AppLocalizations.of(context)!.changeTheme,
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
            title: AppLocalizations.of(context)!.changeLanguage,
            leadingIcon: Icons.language,
            leadingIconColor: AppColor.green,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              _onChangeLanguage(context);
            },
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: AppLocalizations.of(context)!.feedback,
            leadingIcon: Icons.rate_review,
            leadingIconColor: AppColor.blue,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              _onFeedback(context);
            },
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: AppLocalizations.of(context)!.share,
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
          SettingItem(
            title: AppLocalizations.of(context)!.version,
            leadingIcon: Icons.system_update,
            leadingIconColor: AppColor.labelColor,
            trailing: const Text(
              AppConstant.appVersion,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SettingItem(
            title: AppLocalizations.of(context)!.logout,
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

  _onChangeLanguage(BuildContext context) {
    List<LocaleModel> languages = [
      LocaleModel(
          languageCode: 'en', name: AppLocalizations.of(context)!.english),
      LocaleModel(
          languageCode: 'es', name: AppLocalizations.of(context)!.spanish)
    ];
    AppUtil.showCupertinoSelection(
      context,
      Localizations.localeOf(context).languageCode,
      languages,
    ).then((code) {
      _localeViewModel.setLocale(Locale(code));
    });
  }

  _onFeedback(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomInputDialog(
          title: AppLocalizations.of(context)!.feedback,
          hint: AppLocalizations.of(context)!.pleaseWriteYourFeedback,
          ok: AppLocalizations.of(context)!.submit,
          cancel: AppLocalizations.of(context)!.cancel,
        );
      },
    ).then((value) {
      if (value != null) {
        AppUtil.debugPrint(value);
        _profileViewModel.sendFeedback(value);
        AppUtil.showSnackBar(
            AppLocalizations.of(context)!.thankYouForYourfeedback);
      }
    });
  }
}

class _ProfileWidget extends StatelessWidget {
  const _ProfileWidget({
    required ProfileViewModel profileViewModel,
  }) : _profileViewModel = profileViewModel;

  final ProfileViewModel _profileViewModel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileViewModel>(
      builder: (controller) => Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const _ProfileImage(),
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
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomBox(
          child:
              AppUtil.checkIsNull(FirebaseAuth.instance.currentUser!.photoURL)
                  ? RandomAvatar(FirebaseAuth.instance.currentUser!.uid,
                      trBackground: true, width: 70, height: 70)
                  : CustomImage(
                      FirebaseAuth.instance.currentUser!.photoURL!,
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
