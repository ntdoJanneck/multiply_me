import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiply_me/classes/math_task.dart';
import 'package:multiply_me/components/in_progress_screen.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:multiply_me/components/widgets/practise_screen_textfield.dart';
import 'package:multiply_me/helpers/dialog_helper.dart';

class MultiplicationTablesScreen extends StatefulWidget {
  const MultiplicationTablesScreen({Key? key}) : super(key: key);

  @override
  _MultiplicationTablesScreenState createState() =>
      _MultiplicationTablesScreenState();
}

class _MultiplicationTablesScreenState
    extends State<MultiplicationTablesScreen> {
  final baseNumberController = TextEditingController();
  final rangeANumberController = TextEditingController();
  final rangeBNumberController = TextEditingController();

  bool randomizeValue = false;

  /// Start a practise round
  void startPractise() {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    // Parse Numbers
    double base = -1;
    double rangeA = -1;
    double rangeB = -1;

    if (baseNumberController.text == "" ||
        rangeANumberController.text == "" ||
        rangeBNumberController.text == "") {
      DialogHelper.showInfoDialog(
        context,
        localization!.multiplicationTableErrorHeadline,
        localization.multiplicationTableErrorFillInAll,
      );
      return;
    }

    base = double.parse(baseNumberController.text);
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

    // Generate Tasks
    for (double i = rangeA; i <= rangeB; i++) {
      taskItems.add(MathTask(i, base, "×"));
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
  void dispose() {
    baseNumberController.dispose();
    rangeANumberController.dispose();
    rangeBNumberController.dispose();
    super.dispose();
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
                  PractiseScreenInputTextField(
                    label: localization.multiplicationTableTable,
                    maxInput: 100,
                    controller: baseNumberController,
                    disableFlexible: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      PractiseScreenInputTextField(
                          label: localization.multiplicationTableRangeA,
                          maxInput: 100,
                          controller: rangeANumberController),
                      const SizedBox(
                        width: 10,
                      ),
                      PractiseScreenInputTextField(
                          label: localization.multiplicationTableRangeB,
                          maxInput: 100,
                          controller: rangeBNumberController),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
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
