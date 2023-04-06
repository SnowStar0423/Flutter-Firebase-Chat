import 'package:flutter/material.dart';
import '../../utils/static_content.dart';
import '../theme/app_color.dart';
import 'custom_button.dart';

// ignore: must_be_immutable
class TermService extends StatefulWidget {
  TermService({required this.onAccept, super.key});

  Function() onAccept;

  @override
  State<TermService> createState() => _TermServiceState();
}

class _TermServiceState extends State<TermService> {
  bool _checkedRead = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const Text(
              "Terms of Service",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(termData),
            FittedBox(
              child: Row(
                children: [
                  Checkbox(value: _checkedRead, onChanged: _onCheckedChanged),
                  const Text("I've read and agree to the terms."),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildAcceptButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _buildAcceptButton() {
    return AbsorbPointer(
      absorbing: !_checkedRead,
      child: CustomButton(
        bgColor: _checkedRead ? AppColor.primary : AppColor.grey,
        height: 40,
        title: "Accept",
        onTap: widget.onAccept,
      ),
    );
  }

  _onCheckedChanged(value) {
    setState(() {
      _checkedRead = value ?? !_checkedRead;
    });
  }
}
