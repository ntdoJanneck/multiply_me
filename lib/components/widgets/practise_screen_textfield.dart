import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PractiseScreenInputTextField extends StatefulWidget {
  const PractiseScreenInputTextField(
      {Key? key,
      required this.label,
      required this.maxInput,
      required this.controller,
      this.onSubmit,
      this.disableFlexible = false})
      : super(key: key);
  final String label;
  final int maxInput;
  final TextEditingController controller;
  final Function(String value)? onSubmit;
  final bool disableFlexible;

  @override
  State<PractiseScreenInputTextField> createState() =>
      _PractiseScreenInputTextFieldState();
}

class _PractiseScreenInputTextFieldState
    extends State<PractiseScreenInputTextField> {
  @override
  Widget build(BuildContext context) {
    Widget textField = TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: widget.label),
      controller: widget.controller,
      onSubmitted: widget.onSubmit,
      onChanged: (input) {
        if (input == "") {
          return;
        }
        if (double.parse(input) > widget.maxInput) {
          widget.controller.text = widget.maxInput.toStringAsFixed(0);
        }
      },
    );
    if (widget.disableFlexible) {
      return textField;
    }
    return Flexible(child: textField);
  }
}
