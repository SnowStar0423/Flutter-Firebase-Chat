import 'package:chat_app/core/utils/app_asset.dart';
import 'package:chat_app/core/style/app_color.dart';
import 'package:chat_app/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:chat_app/view/widgets/custom_dialog.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conPasswordController = TextEditingController();
  final btnController = RoundedLoadingButtonController();
  final AuthViewModel _authViewModel = Get.find();
  late AppLocalizations _local;

  @override
  void didChangeDependencies() {
    _local = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _conPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: _LoginButton(local: _local),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const _LogoWidet(),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                _local.register,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            _buildNameBlock(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            _buildEmailBlock(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            _buildPassowrdBlcok(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            _buildConPassowrdBlock(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 30,
            ),
            _RegisterButton(
                btnController: btnController,
                authViewModel: _authViewModel,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                conPasswordController: _conPasswordController,
                local: _local),
          ],
        ),
      ),
    );
  }

  Widget _buildNameBlock() {
    return CustomTextField(
      controller: _nameController,
      leadingIcon: const Icon(
        Icons.person_outline,
        color: Colors.grey,
      ),
      hintText: _local.name,
    );
  }

  Widget _buildEmailBlock() {
    return CustomTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      leadingIcon: const Icon(
        Icons.email_outlined,
        color: Colors.grey,
      ),
      hintText: _local.email,
    );
  }

  Widget _buildPassowrdBlcok() {
    return Obx(
      () => CustomTextField(
        controller: _passwordController,
        leadingIcon: const Icon(
          Icons.lock_outline,
          color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            _authViewModel.hideShowPassword();
          },
          child: Icon(
              _authViewModel.isObscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey),
        ),
        obscureText: _authViewModel.isObscurePassword,
        hintText: _local.password,
      ),
    );
  }

  Widget _buildConPassowrdBlock() {
    return Obx(
      () => CustomTextField(
        controller: _conPasswordController,
        leadingIcon: const Icon(
          Icons.lock_outline,
          color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            _authViewModel.hideShowConfirmPassword();
          },
          child: Icon(
              _authViewModel.isObscureConPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey),
        ),
        obscureText: _authViewModel.isObscureConPassword,
        hintText: _local.confirmPassword,
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    required this.btnController,
    required AuthViewModel authViewModel,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController conPasswordController,
    required AppLocalizations local,
  })  : _authViewModel = authViewModel,
        _nameController = nameController,
        _emailController = emailController,
        _passwordController = passwordController,
        _conPasswordController = conPasswordController,
        _local = local;

  final RoundedLoadingButtonController btnController;
  final AuthViewModel _authViewModel;
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _conPasswordController;
  final AppLocalizations _local;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RoundedLoadingButton(
            width: MediaQuery.of(context).size.width,
            color: AppColor.primary,
            controller: btnController,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              bool res = await _authViewModel.registerWithEmailPassword(
                  name: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  confirmPassword: _conPasswordController.text);
              if (res) {
                btnController.success();
                Get.back();
              } else {
                btnController.reset();
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogBox(
                        title: _local.register,
                        descriptions: _authViewModel.message,
                      );
                    },
                  );
                }
              }
            },
            child: Text(
              _local.register,
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

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required AppLocalizations local,
  }) : _local = local;

  final AppLocalizations _local;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 80,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              _local.login,
              style: const TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _LogoWidet extends StatelessWidget {
  const _LogoWidet();

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
