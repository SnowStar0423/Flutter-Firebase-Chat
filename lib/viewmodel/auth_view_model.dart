import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/utils/app_global.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../service/analytics_service.dart';
import '../utils/app_util.dart';

class AuthViewModel extends GetxController {
  AuthViewModel({required this.firebaseAuth, required this.userService});
  final FirebaseAuth firebaseAuth;
  final UserService userService;
  final RxBool _isObscurePassword = true.obs;
  final RxBool _isObscureConPassword = true.obs;
  String _message = "";
  final RxBool _loading = false.obs;
  final _analyticsService = AnalyticsService();

  hideShowPassword() => _isObscurePassword.value = !_isObscurePassword.value;
  hideShowConfirmPassword() =>
      _isObscureConPassword.value = !_isObscureConPassword.value;

  bool get isObscurePassword => _isObscurePassword.value;
  bool get isObscureConPassword => _isObscureConPassword.value;

  getMessage() => _message;
  setMessage(ms) => _message = ms;

  set loading(bool value) => _loading.value = value;
  bool get loading => _loading.value;

  Future<bool> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      if (!_validateEmail(email) || !_validatePassword(password)) return false;
      final res = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      AppUtil.debugPrint(res.user);
      userService.addUser(AppGlobal().firebaseUserToChatUser(res.user!));
      setMessage("successfully logged in");
      _analyticsService.setUserProperties(
          userId: firebaseAuth.currentUser!.uid);
      _analyticsService.logLogin();
      return true;
    } on FirebaseException catch (e) {
      AppUtil.debugPrint(e.toString());
      setMessage(e.message.toString());
      return false;
    } catch (e) {
      setMessage("Failed to login.");
      return false;
    }
  }

  bool _validateEmail(String email) {
    if (AppUtil.checkIsNull(email.trim())) {
      setMessage("please enter your email");
      return false;
    } else if (!GetUtils.isEmail(email)) {
      setMessage("Invalid email");
      return false;
    }
    return true;
  }

  bool _validateName(String name) {
    if (AppUtil.checkIsNull(name.trim())) {
      setMessage("please enter your name");
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (AppUtil.checkIsNull(password.trim())) {
      setMessage("please enter password");
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword(String conPassword) {
    if (AppUtil.checkIsNull(conPassword.trim())) {
      setMessage("please enter confirm password");
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
      setMessage("Password and Confirm Password are not matched.");
      return false;
    }
    return true;
  }

  Future<bool> registerWithEmailPassword(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    if (!validateForm(name, email, password, confirmPassword)) return false;
    try {
      final res = await firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      AppUtil.debugPrint(res.user);
      if (res.user != null) {
        await res.user!.updateDisplayName(name.trim());
        await firebaseAuth.currentUser!.reload();
        userService.addUser(
            AppGlobal().firebaseUserToChatUser(firebaseAuth.currentUser!));
      }
      setMessage("successfully registered in");
      _analyticsService.setUserProperties(
          userId: firebaseAuth.currentUser!.uid);
      _analyticsService.logSignUp();
      return true;
    } on FirebaseException catch (e) {
      AppUtil.debugPrint(e.toString());
      setMessage(e.message.toString());
      return false;
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      setMessage("Failed to register.");
      return false;
    }
  }

  signOut() async {
    var tempUser = _removeUserDeviceToken(firebaseAuth.currentUser!);
    await userService.addUser(tempUser);
    await firebaseAuth.signOut();
    Get.delete<ChatViewModel>();
    AppUtil.debugPrint(firebaseAuth.currentUser);
    _analyticsService.logEvent(eventName: "signOut");
  }

  ChatUser _removeUserDeviceToken(User user) {
    ChatUser temp = AppGlobal().firebaseUserToChatUser(user);
    temp.deviceToken = '';
    return temp;
  }

  Future<bool> submitResetPasswordEmail(String email) async {
    if (!_validateEmail(email)) return false;

    loading = true;
    try {
      await firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((value) async {
        loading = false;
        setMessage(
          'Reset password link was sent to $email',
        );
        return true;
      });
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e.toString());
      return false;
    } finally {
      loading = false;
    }
    return true;
  }
}
