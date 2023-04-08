import 'package:flutter/material.dart';

class RoundTextBox extends StatelessWidget {
  const RoundTextBox(
      {this.controller,
      Key? key,
      this.keyboardType,
      this.onTap,
      this.onChanged,
      this.height = 45,
      this.readOnly = false})
      : super(key: key);
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
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
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        keyboardType: keyboardType,
        // style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
        ),
      ),
    );
  }
}
