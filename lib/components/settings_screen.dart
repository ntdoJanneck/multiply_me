import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:multiply_me/theme_provider/theme_model.dart';
import "package:provider/provider.dart";
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
      },
    );
  }

  Future<ThemeMode?> showThemeDialog(
      BuildContext context, ThemeModel themeModel) async {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    ThemeMode? result = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        ThemeMode _mode = themeModel.theme;
        return AlertDialog(
          title: Text(localization!.settingsThemeHeadline),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<ThemeMode>(
                    title: Text(localization.settingsThemeSystem),
                    value: ThemeMode.system,
                    groupValue: _mode,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        _mode = value!;
                      });
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(localization.settingsThemeLight),
                    value: ThemeMode.light,
                    groupValue: _mode,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        _mode = value!;
                      });
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(localization.settingsThemeDark),
                    value: ThemeMode.dark,
                    groupValue: _mode,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        _mode = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context, themeModel.theme);
                },
                child: Text(localization.settingsCancel)),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, _mode);
                },
                child: Text(localization.settingsSave)),
          ],
        );
      },
    );

    if (result != null) {
      return result;
    }
    return null;
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    Map<ThemeMode, String> themeTranslations = {
      ThemeMode.system: localization!.settingsThemeSystem,
      ThemeMode.dark: localization.settingsThemeDark,
      ThemeMode.light: localization.settingsThemeLight,
    };
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<ThemeModel>(builder: (context, themeModel, child) {
          ThemeMode theme = themeModel.theme;
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined),
                title: Text(localization.settingsDeleteStatisticsDataTitle),
                onTap: () => {
                  showConfirmationDialog(
                      localization.multiplicationTableErrorHeadline,
                      localization
                          .settingsDeleteStatisticsDataConfirmationMessage,
                      localization.dialogYes,
                      localization.dialogNo)
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_4_outlined),
                title: Text(localization.settingsThemeHeadline),
                subtitle: Text(themeTranslations[theme] ??
                    localization.settingsThemeSystem),
                onTap: () async {
                  ThemeMode? newTheme =
                      await showThemeDialog(context, themeModel);
                  if (newTheme != null) {
                    setState(() {
                      theme = newTheme;
                      themeModel.setTheme(theme);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: Text(localization.settingsChangelogHeadline),
                onTap: () => MarkdownDialog.buildMarkdownModal(
                    context,
                    localization.settingsChangelogFile,
                    localization.settingsChangelogHeadline),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(localization.settingsViewImprintTitle),
                onTap: () => MarkdownDialog.buildMarkdownModal(context,
                    "imprint.md", localization.settingsViewImprintTitle),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(localization.settingsAboutViewTitle),
                onTap: () => {
                  showAboutDialog(
                    context: context,
                    applicationName: "MultiplyMe",
                    applicationLegalese: localization.settingsAboutViewLegalese,
                    applicationVersion: "1.1.0",
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
                    ],
                  )
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
