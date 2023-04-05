import 'package:flutter/material.dart';
import '../../utils/app_asset.dart';

class NotFound extends StatelessWidget {
  const NotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 300,
            height: 300,
            child: Image.asset(AppAsset.notFound),
          ),
        ),
      ),
    );
  }
}
