import 'package:flutter/material.dart';

class DialogHelper {
  /// Shows a simple alert with an "okay" button (no yes/no options, just for info!)
  static void showInfoDialog(BuildContext context, String title, String content,
      {String confirmText = "Okay"}) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text(confirmText))
          ],
        );
      },
    );
  }
}
