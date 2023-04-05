import 'package:chat_app/utils/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
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
      final res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (res.user != null) {
        await res.user!.updateDisplayName(name);
        await _firebaseAuth.currentUser!.reload();
      }
      return res;
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      rethrow;
    }
  }

  Future resetPasswordEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      rethrow;
    }
  }
}
