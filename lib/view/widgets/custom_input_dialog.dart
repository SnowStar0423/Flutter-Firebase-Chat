import 'package:flutter/material.dart';

class CustomInputDialog extends StatefulWidget {
  const CustomInputDialog(
      {super.key,
      required this.title,
      required this.hint,
      this.cancel = 'Cancel',
      this.ok = 'Ok'});

  final String title;
  final String hint;
  final String cancel;
  final String ok;

  @override
  State<CustomInputDialog> createState() => _CustomInputDialogState();
}

class _CustomInputDialogState extends State<CustomInputDialog> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 260,
        child: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            const Divider(),
            TextField(
              controller: _textEditingController,
              maxLines: 5,
              decoration: InputDecoration(hintText: widget.hint),
            ),
            const SizedBox(
              height: 15,
            ),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text(widget.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text(widget.ok),
                    onPressed: () {
                      Navigator.of(context).pop(_textEditingController.text);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
