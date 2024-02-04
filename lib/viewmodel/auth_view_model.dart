import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/user_service.dart';
import 'package:chat_app/core/utils/app_global.dart';
import 'package:chat_app/core/utils/firebase_constant.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chat_app/core/services/analytics_service.dart';
import 'package:chat_app/core/utils/app_util.dart';

class AuthViewModel extends GetxController {
  AuthViewModel({required this.authService, required this.userService});
  final AuthService authService;
  final UserService userService;
  final RxBool _isObscurePassword = true.obs;
  final RxBool _isObscureConPassword = true.obs;
  String message = "";
  final RxBool _loading = false.obs;
  final _analyticsService = AnalyticsService();
  late AppLocalizations _local;

  @override
  void onReady() {
    _local = AppLocalizations.of(Get.context!)!;
    super.onReady();
  }

  hideShowPassword() => _isObscurePassword.value = !_isObscurePassword.value;
  hideShowConfirmPassword() =>
      _isObscureConPassword.value = !_isObscureConPassword.value;

  bool get isObscurePassword => _isObscurePassword.value;
  bool get isObscureConPassword => _isObscureConPassword.value;

  set loading(bool value) => _loading.value = value;
  bool get loading => _loading.value;

  Future<bool> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      if (!_validateEmail(email) || !_validatePassword(password)) return false;
      final res = await authService.signInWithEmailPassword(
          email: email, password: password);
      AppUtil.debugPrint(res.user);
      userService.addUser(
        ChatUser.fromFirebaseUser(res.user!, AppGlobal.instance.deviceToken),
      );
      message = _local.successfullyLoggedIn;
      _analyticsService.setUserProperties(userId: authService.currentUser!.uid);
      _analyticsService.logLogin();
      return true;
    } on FirebaseException catch (e) {
      AppUtil.debugPrint(e.toString());
      message = e.message.toString();
      return false;
    } catch (e) {
      message = _local.failedToLogin;
      return false;
    }
  }

  Future<bool> registerWithEmailPassword(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    if (!validateForm(name, email, password, confirmPassword)) return false;
    try {
      final res = await authService.registerWithEmailPassword(
          name: name.trim(), email: email.trim(), password: password.trim());
      AppUtil.debugPrint(res.user);
      if (res.user != null) {
        var user = ChatUser.fromFirebaseUser(
          authService.currentUser!,
          AppGlobal.instance.deviceToken,
        )..onlineStatus = UserOnlineStatus.online;
        await userService.addUser(user);
      }
      message = _local.successfullyRegistered;

      _analyticsService.setUserProperties(userId: authService.currentUser!.uid);
      _analyticsService.logSignUp();
      return true;
    } on FirebaseException catch (e) {
      AppUtil.debugPrint(e.toString());
      message = e.message.toString();
      return false;
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      message = _local.failedToRegister;
      return false;
    }
  }

  Future signOut() async {
    await userService.updateUser(authService.currentUser!.uid, {
      ChatUserConstant.onlineStatus: UserOnlineStatus.offline,
      ChatUserConstant.deviceToken: ''
    });
    await authService.signOut();
    await Get.delete<ChatViewModel>();
    _analyticsService.logEvent(eventName: "signOut");
    AppUtil.debugPrint(authService.currentUser);
  }

  Future<bool> submitResetPasswordEmail(String email) async {
    if (!_validateEmail(email)) return false;

    loading = true;
    try {
      await authService.resetPasswordEmail(email);
      loading = false;
      message = '${_local.resetPasswordLinkSentTo} $email';
      return true;
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e.toString());
      return false;
    } finally {
      loading = false;
    }
  }

  bool _validateEmail(String email) {
    if (AppUtil.checkIsNull(email.trim())) {
      message = _local.pleaseEnterEmail;
      return false;
    } else if (!GetUtils.isEmail(email)) {
      message = _local.invalidEmail;
      return false;
    }
    return true;
  }

  bool _validateName(String name) {
    if (AppUtil.checkIsNull(name.trim())) {
      message = _local.pleaseEnterName;
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (AppUtil.checkIsNull(password.trim())) {
      message = _local.pleaseEnterPassword;
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword(String conPassword) {
    if (AppUtil.checkIsNull(conPassword.trim())) {
      message = _local.pleaseEnterConfirmPassword;
      return false;
    }
    return true;
  }

  bool validateForm(
      String name, String email, String password, String confirmPassword) {
    if (!_validateName(name) ||
        !_validateEmail(email) ||
        !_validatePassword(password) ||
        !_validateConfirmPassword(confirmPassword)) {
      return false;
    } else if (password.trim() != confirmPassword.trim()) {
      message = _local.passwordAndConfirmPasswordNotMatch;
      return false;
    }
    return true;
  }
}
