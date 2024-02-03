import 'package:chat_app/core/utils/app_asset.dart';
import 'package:chat_app/core/style/app_color.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  final String title;
  final String descriptions;
  final String text;
  final String? img;

  const CustomDialogBox(
      {super.key,
      this.title = "Message",
      this.descriptions = "",
      this.text = "Ok",
      this.img});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: _Constants.padding,
            top: _Constants.avatarRadius + _Constants.padding,
            right: _Constants.padding,
            bottom: _Constants.padding,
          ),
          margin: const EdgeInsets.only(top: _Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(_Constants.padding),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                descriptions,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    text,
                    style:
                        const TextStyle(fontSize: 18, color: AppColor.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          left: _Constants.padding,
          right: _Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: _Constants.avatarRadius,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Image(
                image: AssetImage(
                  AppAsset.logo,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Constants {
  _Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
