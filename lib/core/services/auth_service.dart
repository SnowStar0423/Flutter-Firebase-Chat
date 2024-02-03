import 'package:chat_app/core/utils/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;
  User? get currentUser => firebaseAuth.currentUser;

  Future<UserCredential> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      rethrow;
    }
  }

  Future<UserCredential> registerWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final res = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (res.user != null) {
        await res.user!.updateDisplayName(name);
        await firebaseAuth.currentUser!.reload();
      }
      return res;
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      rethrow;
    }
  }

  Future resetPasswordEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      rethrow;
    }
  }
}
