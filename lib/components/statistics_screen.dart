import 'dart:developer';

import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:intl/intl.dart';
import 'package:multiply_me/classes/analytics_data.dart';
import 'package:multiply_me/classes/analytics_math_session.dart';
import 'package:multiply_me/components/detail_analytics_screen.dart';
import 'package:multiply_me/components/finished_screen.dart';
import 'package:multiply_me/helpers/save_file_loader.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String getPercentage(double part, double of) {
    double result = (part / of) * 100;
    return (result.toStringAsFixed(result.truncate() == result ? 0 : 2));
  }

  Future<Column> buildAnalyticsList() async {
    AnalyticsData data = await SaveFileLoader.getAnalyticsData();
    data.content = data.content.reversed.toList();
    List<Widget> items = [];

    for (MathSession item in data.content) {
      Widget card = Card(
        child: ListTile(
          trailing: const Icon(Icons.arrow_forward),
          title: Text(DateFormat("dd.MM.yyyy, HH:mm").format(item.sessionDate)),
          subtitle: Row(
            children: [
              const Icon(
                Icons.check,
                color: Colors.grey,
              ),
              Text(
                  "${getPercentage(item.correct, item.tasks.length.toDouble())}%"),
              const SizedBox(
                width: 2,
              ),
              const Icon(
                Icons.close,
                color: Colors.grey,
              ),
              Text(
                  "${getPercentage(item.wrong, item.tasks.length.toDouble())}%"),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DetailAnalyticsScreen(resultList: item.tasks)));
          },
        ),
      );
      items.add(card);
    }
    var result = Column(
        children: (items.isNotEmpty)
            ? items
            : [const Center(child: Text("No Data!"))]);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    return Scaffold(
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: buildAnalyticsList(),
            builder: (BuildContext context, AsyncSnapshot<Column> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
