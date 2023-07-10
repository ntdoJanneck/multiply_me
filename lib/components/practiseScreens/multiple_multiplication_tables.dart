
import 'package:flutter/material.dart';
import 'package:multiply_me/classes/math_task.dart';
import 'package:multiply_me/components/in_progress_screen.dart';

import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:multiply_me/components/widgets/practise_screen_base.dart';
import 'package:multiply_me/components/widgets/practise_screen_textfield.dart';

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
        ActionChip(
          label: Text(item.toStringAsFixed(0)),
          avatar: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              tables.remove(item);
            });
          },
        ),
      );
    }
    return result;
  }

  void handleAddTableInput() {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    if (tableInputController.text == "") {
      DialogHelper.showInfoDialog(
          context,
          localization!.multiplicationTableErrorHeadline,
          localization.multiplicationTableErrorDidNotInputNumber);
    } else if (tables.contains(double.parse(tableInputController.text))) {
      DialogHelper.showInfoDialog(
          context,
          localization!.multiplicationTableErrorHeadline,
          localization.multiplicationTableErrorAlreadyAddedTable);
    } else {
      setState(
        () {
          tables.add(double.parse(tableInputController.text));
          tableInputController.clear();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    List<Widget> screen = [
      Row(
        children: [
          PractiseScreenInputTextField(
            controller: tableInputController,
            label: localization!.multiplicationTableAddTable,
            onSubmit: (input) => handleAddTableInput(),
            maxInput: 100,
          ),
          const SizedBox(
            width: 20,
          ),
          Ink(
            decoration: const ShapeDecoration(shape: CircleBorder()),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: handleAddTableInput,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              direction: Axis.horizontal,
              children: buildGridItems(tables),
            )
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          PractiseScreenInputTextField(
            controller: rangeANumberController,
            label: localization.multiplicationTableRangeA,
            maxInput: 100,
          ),
          const SizedBox(
            width: 10,
          ),
          PractiseScreenInputTextField(
            controller: rangeBNumberController,
            label: localization.multiplicationTableRangeB,
            maxInput: 100,
          ),
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
        },
      ),
    ];
    return PractiseScreenBase(
        title: localization.multiplicationTableHeadline,
        children: screen,
        onSubmit: () {
          startPractise(context);
        });
  }
}
