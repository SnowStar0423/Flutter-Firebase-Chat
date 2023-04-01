import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/utils/app_global.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../utils/app_util.dart';

class AuthViewModel extends GetxController {
  AuthViewModel({required this.firebaseAuth, required this.userService});
  final FirebaseAuth firebaseAuth;
  final UserService userService;
  final RxBool _isObscurePassword = true.obs;
  final RxBool _isObscureConPassword = true.obs;
  String _message = "";

  // final AnalyticsService _analyticsService = AnalyticsService();

  hideShowPassword() => _isObscurePassword.value = !_isObscurePassword.value;
  hideShowConfirmPassword() =>
      _isObscureConPassword.value = !_isObscureConPassword.value;

  bool get isObscurePassword => _isObscurePassword.value;
  bool get isObscureConPassword => _isObscureConPassword.value;

  getMessage() => _message;
  setMessage(ms) => _message = ms;

  Future<bool> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final res = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      AppUtil.debugPrint(res.user);
      userService.addUser(AppGlobal().firebaseUserToChatUser(res.user!));
      setMessage("successfully logged in");
      // _analyticsService.setUserProperties(
      //     userId: firebaseAuth.currentUser!.uid);
      // _analyticsService.logLogin();
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

  bool validateForm(
      String name, String email, String password, String confirmPassword) {
    if (password != confirmPassword) {
      _message = "Password and Confirm Password are not matched.";
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
          email: email, password: password);
      AppUtil.debugPrint(res.user);
      if (res.user != null) {
        await res.user!.updateDisplayName(name);
        await firebaseAuth.currentUser!.reload();
        userService.addUser(
            AppGlobal().firebaseUserToChatUser(firebaseAuth.currentUser!));
      }
      setMessage("successfully registered in");
      // _analyticsService.setUserProperties(
      //     userId: firebaseAuth.currentUser!.uid);
      // _analyticsService.logSignUp();
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
    // _analyticsService.logEvent(eventName: "signOut");
  }

  ChatUser _removeUserDeviceToken(User user) {
    ChatUser temp = AppGlobal().firebaseUserToChatUser(user);
    temp.deviceToken = '';
    return temp;
  }
}
