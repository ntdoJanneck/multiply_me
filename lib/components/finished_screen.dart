import 'package:flutter/material.dart';
import 'package:multiply_me/classes/analytics_data.dart';
import 'package:multiply_me/classes/analytics_math_session.dart';
import 'package:multiply_me/classes/analytics_math_task.dart';
import 'package:multiply_me/classes/math_result.dart';
import 'package:multiply_me/helpers/save_file_loader.dart';
import 'package:multiply_me/main.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class FinishedScreen extends StatefulWidget {
  const FinishedScreen({Key? key, required this.resultList}) : super(key: key);

  final List<MathResult> resultList;

  @override
  _FinishedScreenState createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  List<AnalyticsMathTask> analyticsList = [];

  void finishSession() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainApp()));
  }

  /// Returns a list of Widgets for the main part of the end screen. Also calculates all needed data for the summary at the top!
  List<Widget> buildResultList(List<MathResult> input) {
    List<Widget> results = <Widget>[];
    List<Duration> durationList = [];

    List<AnalyticsMathTask> analyticsTasks = [];

    for (MathResult item in input) {
      Duration time = item.endTime.difference(item.startTime);
      durationList.add(time);

      Widget cardIcon =
          (item.answerGiven == (item.task.firstFigure * item.task.secondFigure))
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.close,
                  color: Colors.red,
                );

      results.add(Card(
        child: Column(
          children: [
            ListTile(
              leading: cardIcon,
              title: Text(
                  "${item.task.firstFigure.toStringAsFixed(0)} ${item.task.mathSign} ${item.task.secondFigure.toStringAsFixed(0)} = ${item.answerGiven.toStringAsFixed(0)}"),
              subtitle: Text(_printDuration(time)),
            )
          ],
        ),
      ));

      //add the item to the statistic List
      AnalyticsMathTask temp = AnalyticsMathTask(
          item.task.firstFigure,
          item.task.secondFigure,
          item.task.mathSign,
          item.answerGiven,
          (item.answerGiven ==
              (item.task.firstFigure * item.task.secondFigure)),
          item.startTime,
          item.endTime,
          time);
      analyticsTasks.add(temp);
    }

    MathSession session = MathSession(
      analyticsTasks,
    );
    AnalyticsData data = AnalyticsData([]);
    data = data.addNewSession(session);

    SaveFileLoader.saveNewSessionToAnalyticsData(session);

    return results;
  }

  String getPercentage(double part, double of) {
    double result = (part / of) * 100;
    return (result.toStringAsFixed(result.truncate() == result ? 0 : 2));
  }

  /// Returns the Duration of a task as a string
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    int tempTotalCorrect = 0;
    int tempTotalWrong = 0;

    for (MathResult item in widget.resultList) {
      if (item.answerGiven ==
          (item.task.firstFigure * item.task.secondFigure)) {
        tempTotalCorrect++;
      } else {
        tempTotalWrong++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(localization!.resultsHeadline),
        actions: [
          IconButton(
              onPressed: () {
                finishSession();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text(localization.resultsHeaderMessage),
                    ),
                    ListTile(
                      leading: const Icon(Icons.check),
                      title: Text(localization.resultsTotalCorrectMessage(
                          tempTotalCorrect,
                          widget.resultList.length,
                          getPercentage(tempTotalCorrect.toDouble(),
                              widget.resultList.length.toDouble()))),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.close,
                      ),
                      title: Text(localization.resultsTotalWrongMessage(
                          tempTotalWrong,
                          widget.resultList.length,
                          getPercentage(tempTotalWrong.toDouble(),
                              widget.resultList.length.toDouble()))),
                    ),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.timer,
                    //   ),
                    //   title: Text("Average Time: $avgTime"),
                    // ),
                    // ignore: todo
                    /// TODO: Implement avg Time!
                    const Divider(
                      height: 10,
                    ),
                    Column(
                      children: buildResultList(widget.resultList),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Ink(
                      decoration: const ShapeDecoration(
                          shape: CircleBorder(), color: Colors.green),
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () {
                          finishSession();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
