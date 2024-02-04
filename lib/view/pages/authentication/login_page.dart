import 'package:chat_app/core/utils/app_asset.dart';
import 'package:chat_app/core/router/app_route.dart';
import 'package:chat_app/core/utils/app_util.dart';
import 'package:chat_app/core/style/app_color.dart';
import 'package:chat_app/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:chat_app/view/widgets/custom_dialog.dart';
import 'package:chat_app/view/widgets/custom_image.dart';
import 'package:chat_app/view/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final btnController = RoundedLoadingButtonController();
  final AuthViewModel _authViewModel = Get.find();
  late AppLocalizations _local;

  @override
  void didChangeDependencies() {
    _local = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUtil.showTermsService();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: buildBody(),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: _RegisterButton(local: _local),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  buildBody() {
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
            const _LogoWidget(),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                _local.login,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            _buildEmailBlock(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            _buildPasswordBlock(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 18,
            ),
            _ForgotPasswordWidget(local: _local),
            const SizedBox(
              height: 25,
            ),
            _buildLoginButton()
          ],
        ),
      ),
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

  Widget _buildPasswordBlock() {
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

  Widget _buildLoginButton() {
    return _LoginButton(
      btnController: btnController,
      authViewModel: _authViewModel,
      emailController: _emailController,
      passwordController: _passwordController,
      local: _local,
    );
  }
}

class _ForgotPasswordWidget extends StatelessWidget {
  const _ForgotPasswordWidget({
    required AppLocalizations local,
  }) : _local = local;

  final AppLocalizations _local;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () async {
          Get.toNamed(AppRoute.forgotPasswordPage);
        },
        child: Text(
          _local.forgotPassword,
          style: const TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    required AppLocalizations local,
  }) : _local = local;

  final AppLocalizations _local;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoute.registerPage);
          },
          child: Container(
            width: 90,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
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
              _local.register,
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

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.btnController,
    required AuthViewModel authViewModel,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required AppLocalizations local,
  })  : _authViewModel = authViewModel,
        _emailController = emailController,
        _passwordController = passwordController,
        _local = local;

  final RoundedLoadingButtonController btnController;
  final AuthViewModel _authViewModel;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
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
              var res = await _authViewModel.signInWithEmailPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
              if (res) {
                btnController.success();
              } else {
                btnController.reset();
                if (context.mounted) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: _local.login,
                          descriptions: _authViewModel.message,
                        );
                      });
                }
              }
            },
            child: Text(
              _local.login,
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
