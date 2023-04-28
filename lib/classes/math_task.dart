class MathTask {
  late double firstFigure;
  late double secondFigure;
  late String mathSign;

  MathTask(double pFirstFigure, double pSecondFigure, String pSign) {
    firstFigure = pFirstFigure;
    secondFigure = pSecondFigure;
    mathSign = pSign;
  }

  double calculateResult() {
    return firstFigure * secondFigure;
  }
}
