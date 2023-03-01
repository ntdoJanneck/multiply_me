import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiply_me/classes/math_task.dart';
import 'package:multiply_me/components/in_progress_screen.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

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
    // Parse Numbers
    if (baseNumberController.text != "" &&
        rangeANumberController.text != "" &&
        rangeBNumberController.text != "") {
      double base = double.parse(baseNumberController.text);
      double rangeA = double.parse(rangeANumberController.text);
      double rangeB = double.parse(rangeBNumberController.text);
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
    } else {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            var localization =
                Localizations.of<AppLocalizations>(context, AppLocalizations);
            return AlertDialog(
              title: Text(localization!.multiplicationTableErrorHeadline),
              content: Text(localization.multiplicationTableErrorFillInAll),
              actions: [
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text("Okay"))
              ],
            );
          });
    }
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
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: localization.multiplicationTableTable),
                    controller: baseNumberController,
                  ),
                  const SizedBox(
                    height: 10,
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
