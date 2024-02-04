import 'package:chat_app/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:chat_app/core/utils/app_asset.dart';
import 'package:chat_app/core/style/app_color.dart';
import 'package:chat_app/view/widgets/custom_dialog.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _authViewModel = Get.find<AuthViewModel>();
  final RoundedLoadingButtonController _btnSubmitController =
      RoundedLoadingButtonController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const _LogoWidget(),
            const SizedBox(height: 20),
            Center(
              child: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              AppLocalizations.of(context)!.pleaseEnterYourEmailToResetPassword,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 40,
            ),
            _buildEmailBlock(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 25,
            ),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return _SubmitButton(
        btnSubmitController: _btnSubmitController,
        authViewModel: _authViewModel,
        emailController: _emailController);
  }

  Widget _buildEmailBlock() {
    return CustomTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      leadingIcon: const Icon(
        Icons.email_outlined,
        color: Colors.grey,
      ),
      hintText: AppLocalizations.of(context)!.email,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required RoundedLoadingButtonController btnSubmitController,
    required AuthViewModel authViewModel,
    required TextEditingController emailController,
  })  : _btnSubmitController = btnSubmitController,
        _authViewModel = authViewModel,
        _emailController = emailController;

  final RoundedLoadingButtonController _btnSubmitController;
  final AuthViewModel _authViewModel;
  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RoundedLoadingButton(
            width: MediaQuery.of(context).size.width,
            color: AppColor.primary,
            controller: _btnSubmitController,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              var res = await _authViewModel
                  .submitResetPasswordEmail(_emailController.text);
              if (res) {
                _btnSubmitController.success();
              } else {
                _btnSubmitController.reset();
              }
              if (context.mounted) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialogBox(
                        title: AppLocalizations.of(context)!.forgotPassword,
                        descriptions: _authViewModel.message,
                      );
                    });
              }
            },
            child: Text(
              AppLocalizations.of(context)!.submit,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        height: 150,
        child: CustomImage(
          AppAsset.logo,
          padding: 10,
          bgColor: Theme.of(context).scaffoldBackgroundColor,
          radius: 5,
        ),
      ),
    );
  }
}
