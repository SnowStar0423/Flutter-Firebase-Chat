import 'package:chat_app/view/pages/chat_page.dart';
import 'package:chat_app/view/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        return snapshot.hasData ? const ChatPage() : const LoginPage();
      }),
    );
  }
}
