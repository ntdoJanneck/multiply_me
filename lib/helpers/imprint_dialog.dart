import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ImprintDialog {
  static Future<void> buildImprint(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization!.settingsViewImprintTitle),
          content: const Text("Lorem ipsum dolor sit amet"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localization.settingsImprintClose))
          ],
        );
      },
    );
  }
}
