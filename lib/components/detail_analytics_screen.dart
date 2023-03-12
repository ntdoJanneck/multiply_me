import 'package:flutter/material.dart';
import 'package:multiply_me/classes/analytics_math_task.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DetailAnalyticsScreen extends StatefulWidget {
  const DetailAnalyticsScreen({Key? key, required this.resultList})
      : super(key: key);

  final List<AnalyticsMathTask> resultList;

  @override
  _DetailAnalyticsScreenState createState() => _DetailAnalyticsScreenState();
}

class _DetailAnalyticsScreenState extends State<DetailAnalyticsScreen> {
  List<AnalyticsMathTask> analyticsList = [];
  Duration totalDuration = const Duration();

  void finishSession() {
    Navigator.of(context).pop();
  }

  /// Returns a list of Widgets for the main part of the end screen. Also calculates all needed data for the summary at the top!
  List<Widget> buildResultList(List<AnalyticsMathTask> input) {
    List<Widget> results = <Widget>[];
    List<Duration> durationList = [];

    for (AnalyticsMathTask item in input) {
      Duration time = item.endTime.difference(item.startTime);
      totalDuration += time;

      durationList.add(time);

      Widget cardIcon =
          (item.answerGiven == (item.firstFigure * item.secondFigure))
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
                  "${item.firstFigure.toStringAsFixed(0)} ${item.mathSign} ${item.secondFigure.toStringAsFixed(0)} = ${item.answerGiven.toStringAsFixed(0)}"),
              subtitle: Text(_printDuration(time)),
            )
          ],
        ),
      ));
    }

    return results;
  }

  String _getPercentage(double part, double of) {
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

    for (AnalyticsMathTask item in widget.resultList) {
      if (item.answerGiven == (item.firstFigure * item.secondFigure)) {
        tempTotalCorrect++;
      } else {
        tempTotalWrong++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(localization!.resultsHeadline),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
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
                      leading: const Icon(Icons.check),
                      title: Text(localization.resultsTotalCorrectMessage(
                          tempTotalCorrect,
                          widget.resultList.length,
                          _getPercentage(tempTotalCorrect.toDouble(),
                              widget.resultList.length.toDouble()))),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.close,
                      ),
                      title: Text(localization.resultsTotalWrongMessage(
                          tempTotalWrong,
                          widget.resultList.length,
                          _getPercentage(tempTotalWrong.toDouble(),
                              widget.resultList.length.toDouble()))),
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Column(
                      children: buildResultList(widget.resultList),
                    ),
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
