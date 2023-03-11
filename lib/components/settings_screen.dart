import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "../helpers/json_utils.dart";
import '../helpers/url_helper.dart';
import "../helpers/imprint_dialog.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void showConfirmationDialog(
      String title, String content, String answerYes, String answerNo) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: Text(answerNo),
              ),
              TextButton(
                child: Text(answerYes),
                onPressed: () async {
                  await JsonUtils.deleteJsonFile("session_data");
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void showAlertBox(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: const Text("Okay"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: Text(localization!.settingsDeleteStatisticsDataTitle),
              onTap: () => {
                showConfirmationDialog(
                    localization.multiplicationTableErrorHeadline,
                    localization
                        .settingsDeleteStatisticsDataConfirmationMessage,
                    localization.dialogYes,
                    localization.dialogNo)
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(localization.settingsViewImprintTitle),
              onTap: () => ImprintDialog.buildImprint(context),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(localization.settingsAboutViewTitle),
              onTap: () => {
                showAboutDialog(
                    context: context,
                    applicationName: "MultiplyMe Beta",
                    applicationLegalese: localization.settingsAboutViewLegalese,
                    applicationVersion: "1.0.0",
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.code_sharp),
                        title: Text(localization.settingsAboutViewSourceCode),
                        onTap: () async {
                          String url =
                              "https://github.com/ntdoJanneck/multiply_me/";
                          bool openResult =
                              await UrlHelper.loadUrl(Uri.parse(url));
                          if (!openResult) {
                            showAlertBox(
                                localization.settingsAboutViewErrorUriHeadline,
                                localization
                                    .settingsAboutViewErrorUriContent(url));
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.shield_outlined),
                        title:
                            Text(localization.settingsAboutViewPrivacyPolicy),
                        onTap: () async {
                          String url =
                              "https://github.com/ntdoJanneck/multiply_me/blob/main/PRIVACY.md";
                          bool openResult =
                              await UrlHelper.loadUrl(Uri.parse(url));
                          if (!openResult) {
                            showAlertBox(
                                localization.settingsAboutViewErrorUriHeadline,
                                localization
                                    .settingsAboutViewErrorUriContent(url));
                          }
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.font_download_outlined),
                        title: Text(localization.settingsAboutViewFontLicense),
                        onTap: () async {
                          String url =
                              "https://github.com/googlefonts/roboto/blob/main/LICENSE";
                          bool openResult =
                              await UrlHelper.loadUrl(Uri.parse(url));
                          if (!openResult) {
                            showAlertBox(
                                localization.settingsAboutViewErrorUriHeadline,
                                localization
                                    .settingsAboutViewErrorUriContent(url));
                          }
                        },
                      )
                    ])
              },
            ),
          ],
        ),
      ),
    );
  }
}
