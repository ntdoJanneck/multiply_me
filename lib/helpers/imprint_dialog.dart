import "dart:developer";

import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/services.dart";
import "package:flutter_markdown/flutter_markdown.dart";

class MarkdownDialog {
  static Future<void> buildMarkdownModal(
      BuildContext context, String filename, String headline) async {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    String text = await MarkdownDialog.getAssetsTextFileContent(filename);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(headline),
          content: SingleChildScrollView(
            child: Container(
              width: 800,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MarkdownBody(
                    data: text,
                    shrinkWrap: true,
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localization!.settingsImprintClose))
          ],
        );
      },
    );
  }

  static Future<String> getAssetsTextFileContent(String filename) async {
    try {
      return await rootBundle.loadString("assets/$filename");
    } catch (e) {
      return "File not found!";
    }
  }
}
