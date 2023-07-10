
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutter/material.dart';

class PractiseScreenBase extends StatefulWidget {
  const PractiseScreenBase(
      {Key? key,
      required this.title,
      required this.children,
      required this.onSubmit})
      : super(key: key);
  final String title;
  final List<Widget> children;
  final Function onSubmit;

  @override
  State<PractiseScreenBase> createState() => _PractiseScreenBaseState();
}

class _PractiseScreenBaseState extends State<PractiseScreenBase> {
  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: Text(localization!.practiseScreenBaseStart),
          onPressed: () => widget.onSubmit(),
          icon: const Icon(Icons.check)),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
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
                children: widget.children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
