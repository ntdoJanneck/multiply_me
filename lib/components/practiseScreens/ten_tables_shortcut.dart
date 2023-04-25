import 'package:flutter/material.dart';
import 'package:multiply_me/components/widgets/practise_screen_base.dart';

import '../../classes/math_task.dart';
import '../in_progress_screen.dart';

import "package:flutter_gen/gen_l10n/app_localizations.dart";

class TenTablesShortcut extends StatefulWidget {
  const TenTablesShortcut({Key? key}) : super(key: key);

  @override
  _TenTablesShortcutState createState() => _TenTablesShortcutState();
}

class _TenTablesShortcutState extends State<TenTablesShortcut> {
  bool randomizeValue = false;

  void startPractise() {
    // Parse Numbers

    List<MathTask> taskItems = <MathTask>[];

    // Generate Tasks
    for (double table = 1; table <= 10; table++) {
      for (double i = 1; i <= 10; i++) {
        taskItems.add(MathTask(i, table, "×"));
      }
    }

    if (randomizeValue) {
      taskItems.shuffle();
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InProgressScreen(
          taskList: taskItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    List<Widget> screens = [
      SwitchListTile(
        title: Text(localization!.multiplicationTableRandomize),
        secondary: const Icon(Icons.shuffle_rounded),
        value: randomizeValue,
        onChanged: (value) => {
          setState(() {
            randomizeValue = value;
          })
        },
      ),
    ];
    return PractiseScreenBase(
        title: localization.multiplicationTableHeadline,
        children: screens,
        onSubmit: () => startPractise());
  }
}
