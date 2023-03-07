import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/services.dart";
import "package:flutter_markdown/flutter_markdown.dart";

class ImprintDialog {
  static Future<void> buildImprint(BuildContext context) async {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    String imprintText = await ImprintDialog.getImprintText();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization!.settingsViewImprintTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //TODO: THIS DOESNT WORK
                MarkdownBody(
                  data: imprintText,
                  shrinkWrap: true,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localization.settingsImprintClose))
          ],
        );
      },
    );
  }

  static Future<String> getImprintText() async {
    try {
      return await rootBundle.loadString("assets/imprint.md");
    } catch (e) {
      return "No imprint!";
    }
  }
}
