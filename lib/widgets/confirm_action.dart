import 'package:flutter/material.dart';

class ConfirmAction extends StatefulWidget {
  const ConfirmAction({Key? key, required this.message, required this.dispatchAction}) : super(key: key);

  final String message;
  final Function dispatchAction;

  @override
  State<ConfirmAction> createState() => _ConfirmActionState();
}

class _ConfirmActionState extends State<ConfirmAction> {
  @override
  Widget build(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        widget.dispatchAction();
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(widget.message),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    return alert;
  }
}
