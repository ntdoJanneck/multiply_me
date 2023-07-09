import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiply_me/classes/math_task.dart';

class SolutionInputTextField extends StatefulWidget {
  const SolutionInputTextField({
    Key? key,
    required this.mathTask,
    required this.focusNode,
    required this.controller,
    required this.onSubmit,
    this.dynamicMaxInput = true,
  }) : super(key: key);

  /// The math task associated with the input field.
  final MathTask mathTask;

  /// If this is set, the max input value will be determined by the solution of the associated [mathTask].
  /// The max input value is 1000 if the solution of the [mathTask] is below 1000.
  /// If the result is above 1000, the next higher digit will be used. For example, if the result of the [mathTask] is 1002, the max input value will be 10000.
  final bool dynamicMaxInput;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String value) onSubmit;
  @override
  State<SolutionInputTextField> createState() => _SolutionInputTextFieldState();
}

class _SolutionInputTextFieldState extends State<SolutionInputTextField> {
  int _calculateDynamicMaxValue(MathTask task) {
    double taskResult = task.calculateResult();
    if (taskResult < 1000) {
      return 1000;
    }
    int digits = taskResult.toStringAsFixed(0).length + 1;
    return pow(10, digits).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        focusNode: widget.focusNode,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          int max = _calculateDynamicMaxValue(widget.mathTask);
          if (value == "") {
            return;
          }
          if (double.parse(value) > max) {
            widget.controller.text = max.toString();
          }
        },
        onSubmitted: (value) {
          widget.onSubmit(value);
        },
        controller: widget.controller,
        style: const TextStyle(fontSize: 20.0),
      ),
    );
  }
}
