import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool validatedField;
  final bool readOnly;
  final bool obscureText;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? hintText;
  final String? labelText;
  final int minLines;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  const CustomTextField({
    super.key,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.controller,
    this.hintText,
    this.labelText,
    this.readOnly = false,
    this.validatedField = true,
    this.errorText = 'Required',
    this.leadingIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: leadingIcon,
        suffixIcon: suffixIcon,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
        labelText: labelText,
        errorText: validatedField ? null : errorText,
      ),
    );
  }
}
