import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiply_me/classes/math_task.dart';
import 'package:multiply_me/components/in_progress_screen.dart';

import "package:flutter_gen/gen_l10n/app_localizations.dart";

import '../../helpers/dialog_helper.dart';

class MultipleMultiplicationTables extends StatefulWidget {
  const MultipleMultiplicationTables({Key? key}) : super(key: key);

  @override
  _MultipleMultiplicationTablesState createState() =>
      _MultipleMultiplicationTablesState();
}

class _MultipleMultiplicationTablesState
    extends State<MultipleMultiplicationTables> {
  final rangeANumberController = TextEditingController();
  final rangeBNumberController = TextEditingController();
  final tableInputController = TextEditingController();

  List<double> tables = <double>[];

  bool randomizeValue = false;

  @override
  void dispose() {
    rangeANumberController.dispose();
    rangeBNumberController.dispose();
    tableInputController.dispose();
    super.dispose();
  }

  /// Start the practise round
  void startPractise(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    double rangeA = -1;
    double rangeB = -1;

    if (rangeANumberController.text == "" ||
        rangeBNumberController.text == "" ||
        tables.isEmpty) {
      DialogHelper.showInfoDialog(
        context,
        localization!.multiplicationTableErrorHeadline,
        localization.multiplicationTableErrorFillInAll,
      );
      return;
    }

    rangeA = double.parse(rangeANumberController.text);
    rangeB = double.parse(rangeBNumberController.text);

    if (rangeA > rangeB) {
      DialogHelper.showInfoDialog(
        context,
        localization!.multiplicationTableErrorHeadline,
        localization.multiplicationTableErrorRangeAGreater,
      );
      return;
    }

    List<MathTask> taskItems = <MathTask>[];

    for (double table in tables) {
      for (double i = rangeA; i <= rangeB; i++) {
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

  /// Returns a list of cards for each element in the input
  List<Widget> buildGridItems(List<double> input) {
    List<Widget> result = <Widget>[];
    for (double item in input) {
      result.add(
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                onTap: () {
                  setState(() {
                    tables.remove(item);
                  });
                },
                title: Text(item.toStringAsFixed(0)),
                trailing: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return result;
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
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  localization.multiplicationTableAddTable),
                          controller: tableInputController,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Ink(
                        decoration:
                            const ShapeDecoration(shape: CircleBorder()),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {
                            if (tableInputController.text == "") {
                              DialogHelper.showInfoDialog(
                                  context,
                                  localization.multiplicationTableErrorHeadline,
                                  localization
                                      .multiplicationTableErrorDidNotInputNumber);
                            } else if (tables.contains(
                                double.parse(tableInputController.text))) {
                              DialogHelper.showInfoDialog(
                                  context,
                                  localization.multiplicationTableErrorHeadline,
                                  localization
                                      .multiplicationTableErrorAlreadyAddedTable);
                            } else {
                              setState(() {
                                tables.add(
                                    double.parse(tableInputController.text));
                                tableInputController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 200,
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, childAspectRatio: 1.7),
                      children: buildGridItems(tables),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  localization.multiplicationTableRangeA),
                          controller: rangeANumberController,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  localization.multiplicationTableRangeB),
                          controller: rangeBNumberController,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
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
                        startPractise(context);
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
