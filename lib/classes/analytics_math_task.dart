import 'package:flutter/services.dart';
import '../helpers/duration_converter.dart';
import "package:duration/duration.dart";

class AnalyticsMathTask {
  late double firstFigure;
  late double secondFigure;
  late String mathSign;
  late double answerGiven;

  late bool correct;

  late DateTime startTime;
  late DateTime endTime;
  late Duration duration;

  AnalyticsMathTask(
      double pFirstFigure,
      double pSecondFigure,
      String pMathSign,
      double pAnswerGiven,
      bool pCorrect,
      DateTime pStartTime,
      DateTime pEndTime,
      Duration pDuration) {
    firstFigure = pFirstFigure;
    secondFigure = pSecondFigure;
    mathSign = pMathSign;
    answerGiven = pAnswerGiven;

    correct = pCorrect;

    startTime = pStartTime;
    endTime = pEndTime;
    duration = pDuration;
  }

  factory AnalyticsMathTask.fromJson(dynamic json) {
    double firstFigure = json["firstFigure"] as double;
    double secondFigure = json["secondFigure"] as double;
    String mathSign = json["mathSign"] as String;
    double answerGiven = json["answerGiven"] as double;
    bool correct = json["correct"] as bool;
    DateTime startTime = DateTime.parse(json["startTime"]);
    DateTime endTime = DateTime.parse(json["endTime"]);
    // Duration duration = parseDuration(json["duration"]);
    Duration duration = DurationConverter.toDuration(json["duration"]);

    return AnalyticsMathTask(firstFigure, secondFigure, mathSign, answerGiven,
        correct, startTime, endTime, duration);
  }

  Map<String, dynamic> toJson() => _analyticsTaskToJson(this);
}

Map<String, dynamic> _analyticsTaskToJson(AnalyticsMathTask instance) =>
    <String, dynamic>{
      "firstFigure": instance.firstFigure,
      "secondFigure": instance.secondFigure,
      "mathSign": instance.mathSign,
      "answerGiven": instance.answerGiven,
      "correct": instance.correct,
      "startTime": instance.startTime.toIso8601String(),
      "endTime": instance.endTime.toIso8601String(),
      "duration": instance.duration.toString()
    };
