import 'package:multiply_me/classes/analytics_math_task.dart';

class MathSession {
  late DateTime sessionDate;

  late double correct;
  late double wrong;

  late List<AnalyticsMathTask> tasks;

  MathSession(List<AnalyticsMathTask> pTasks,
      [DateTime? date, double? pCorrect, double? pWrong]) {
    tasks = pTasks;
    sessionDate = pTasks[0].startTime;

    // Fail Save for older save files: if wrong and correct are not given as parameters, calculate them yourself.
    if (pCorrect == null || pWrong == null) {
      correct = 0;
      wrong = 0;
      for (AnalyticsMathTask task in tasks) {
        if (task.firstFigure * task.secondFigure == task.answerGiven) {
          correct++;
        } else {
          wrong++;
        }
      }
    } else {
      correct = pCorrect;
      wrong = pWrong;
    }
  }

  Map<String, dynamic> toJson() => _sessionToJson(this);

  factory MathSession.fromJson(dynamic json) {
    var tasks = json["tasks"] as List;
    List<AnalyticsMathTask> _items = (json["tasks"] != null)
        ? tasks.map((e) => AnalyticsMathTask.fromJson(e)).toList()
        : [];

    DateTime date = DateTime.parse(json["sessionDate"].toString());
    double correct = json["correct"] as double;
    double wrong = json["wrong"] as double;

    MathSession result = MathSession(_items, date, correct, wrong);
    return result;
  }
}

Map<String, dynamic> _sessionToJson(MathSession instance) {
  List<Map<String, dynamic>> tasks =
      instance.tasks.map((e) => e.toJson()).toList();

  return <String, dynamic>{
    "sessionDate": instance.sessionDate.toIso8601String(),
    "correct": instance.correct,
    "wrong": instance.wrong,
    "tasks": instance.tasks
  };
}
