import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(localization!.multiplicationTableHeadline),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SwitchListTile(
                      title: Text(localization.multiplicationTableRandomize),
                      secondary: const Icon(Icons.shuffle_rounded),
                      value: randomizeValue,
                      onChanged: (value) => {
                            setState(() {
                              randomizeValue = value;
                            })
                          }),
                  const SizedBox(
                    height: 50,
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Colors.green),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () {
                        startPractise();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
