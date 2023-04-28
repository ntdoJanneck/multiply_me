import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiply_me/classes/math_result.dart';
import 'package:multiply_me/classes/math_task.dart';
import 'package:multiply_me/components/finished_screen.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:multiply_me/components/widgets/solution_textfield.dart';

class InProgressScreen extends StatefulWidget {
  const InProgressScreen({Key? key, required this.taskList}) : super(key: key);

  final List<MathTask> taskList;

  @override
  _InProgressScreenState createState() => _InProgressScreenState();
}

class _InProgressScreenState extends State<InProgressScreen> {
  int currentIndex = 0; //Current item from the taskList
  List<MathResult> resultList = <MathResult>[];

  final answerInputController = TextEditingController();

  DateTime timeA = DateTime.now();
  DateTime timeB = DateTime.now();

  late FocusNode answerFocus;

  @override
  void initState() {
    super.initState();
    answerFocus = FocusNode();
  }

  @override
  void dispose() {
    answerInputController.dispose();
    super.dispose();
  }

  void showAllItems(List<MathTask> items) {
    for (MathTask item in items) {
      log("${item.firstFigure} ${item.mathSign} ${item.secondFigure} = ${item.firstFigure * item.secondFigure}");
    }
  }

  void showConfirmationDialog(
      String title, String content, String answerYes, String answerNo) {
    int count = 0;
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () =>
                    {Navigator.of(context).popUntil((_) => count++ >= 1)},
                child: Text(answerNo),
              ),
              TextButton(
                child: Text(answerYes),
                onPressed: () =>
                    {Navigator.of(context).popUntil((_) => count++ >= 2)},
              )
            ],
          );
        });
  }

  void submitSolution(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (answerInputController.text != "") {
      setState(() {
        timeB = DateTime.now();
        //Add answer for the current task
        resultList.add(MathResult(widget.taskList[currentIndex],
            double.parse(answerInputController.text), timeA, timeB));
        timeA = DateTime.now();

        answerInputController.clear();
        answerFocus.requestFocus();
      });
      //Check if the end is reached, if yes move to finishedScreen, else increase index
      if (currentIndex == widget.taskList.length - 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FinishedScreen(resultList: resultList)));
      } else {
        currentIndex++;
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text(localization!.multiplicationTableErrorHeadline),
              content: Text(localization.inProgressErrorDidNotAnswer),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Okay"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => {
            showConfirmationDialog(
                localization!.multiplicationTableErrorHeadline,
                localization.inProgressConfirmQuitMessage,
                localization.dialogYes,
                localization.dialogNo),
          },
        ),
        title: Text(localization!.appTitle),
      ),
      body: Center(
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(localization.inProgressProgressDisplay(
                      (currentIndex + 1).toString(), widget.taskList.length)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "${widget.taskList[currentIndex].firstFigure.toStringAsFixed(0)} ${widget.taskList[currentIndex].mathSign} ${widget.taskList[currentIndex].secondFigure.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 60.0),
                ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "=",
                      style: TextStyle(fontSize: 30.0),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SolutionInputTextField(
                      mathTask: widget.taskList[currentIndex],
                      focusNode: answerFocus,
                      controller: answerInputController,
                      onSubmit: (value) {
                        submitSolution(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Ink(
                      decoration: const ShapeDecoration(shape: CircleBorder()),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          submitSolution(context);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
