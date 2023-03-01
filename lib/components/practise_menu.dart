import "package:multiply_me/components/practiseScreens/multiplication_tables.dart";
import "package:multiply_me/components/practiseScreens/multiple_multiplication_tables.dart";

import 'package:flutter/material.dart';
import 'package:multiply_me/components/practiseScreens/ten_tables_shortcut.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class PractiseMenu extends StatefulWidget {
  const PractiseMenu({Key? key}) : super(key: key);

  @override
  _PractiseMenuState createState() => _PractiseMenuState();
}

class _PractiseMenuState extends State<PractiseMenu> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          Card(
            child: ListTile(
              title: Text(localization!.singleTableTitle),
              subtitle: Text(localization.singleTableDescription),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MultiplicationTablesScreen()))
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(localization.multipleTableTitle),
              subtitle: Text(localization.multipleTableDescription),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MultipleMultiplicationTables()))
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(localization.shortcutTenTitle),
              subtitle: Text(localization.shortcutTenDescription),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TenTablesShortcut()))
              },
            ),
          )
        ],
      ),
    );
  }
}
