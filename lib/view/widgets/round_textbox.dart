import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoundTextBox extends StatelessWidget {
  const RoundTextBox({
    this.controller,
    super.key,
    this.keyboardType,
    this.onTap,
    this.onChanged,
    this.height = 45,
    this.readOnly = false,
    this.autofocus = false,
  });
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool autofocus;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        keyboardType: keyboardType,
        // style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
        ),
      ),
    );
  }
}
