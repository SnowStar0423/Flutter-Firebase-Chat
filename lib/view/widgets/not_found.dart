import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:chat_app/core/utils/app_asset.dart';

class NotFound extends StatelessWidget {
  const NotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Lottie.asset(AppAsset.notFound),
        ),
      ),
    );
  }
}
