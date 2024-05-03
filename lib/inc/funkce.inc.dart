import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gaubeVaha/store/global_keys.dart';

numberFormatter({number, decLength = 2}) {
  number = number ?? 0;
  var noSimbolInUSFormat = NumberFormat.currency(locale: "cs_CZ", symbol: "");

  return noSimbolInUSFormat.format(number);
}

formatDate({date, format = 'yyyy-MM-dd'}) {
  var outputFormat = DateFormat(format);
  return outputFormat.format(date);
}

notificationAlert({context, message}) {
  if (message.isEmpty) return false;

  if (context != null) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  } else {
    final SnackBar snackBar = SnackBar(content: Text(message));
    snackbarKey.currentState?.hideCurrentSnackBar();
    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}

confirmAction({context, message = '', fnc}) {
  var testme = false;
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      fnc;
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(message),
    // content: Text("This is my message."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return testme;
}
