import 'package:chat_app/core/style/app_color.dart';
import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  const CustomBox(
      {super.key,
      required this.child,
      this.bgColor,
      this.borderColor = Colors.transparent,
      this.radius = 50,
      this.isShadow = true,
      this.padding = 5});
  final Widget child;
  final Color borderColor;
  final Color? bgColor;
  final double radius;
  final double padding;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (isShadow)
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
        ],
      ),
      child: child,
    );
  }
}
