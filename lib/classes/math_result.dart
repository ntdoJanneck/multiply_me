import 'package:multiply_me/classes/math_task.dart';

class MathResult {
  late MathTask task;
  late double answerGiven;

  late DateTime startTime;
  late DateTime endTime;

  MathResult(MathTask pTask, double pAnswer, DateTime start, DateTime end) {
    task = pTask;
    answerGiven = pAnswer;
    startTime = start;
    endTime = end;
  }
}
