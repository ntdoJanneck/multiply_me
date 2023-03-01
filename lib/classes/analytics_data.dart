import 'dart:developer';

import 'package:multiply_me/classes/analytics_math_session.dart';

class AnalyticsData {
  late List<MathSession> content;

  AnalyticsData(List<MathSession> initialList) {
    content = initialList;
  }

  AnalyticsData addNewSession(MathSession session) {
    if (content.isNotEmpty) {
      if (content.length == 100) {
        content.removeAt(content.length - 1);
        content.add(session);
      } else {
        content.add(session);
      }
    } else {
      content.add(session);
    }
    log(session.tasks.length.toString());
    return this;
  }

  factory AnalyticsData.fromJson(dynamic json) {
    if (json["content"] != null) {
      var content = json["content"] as List;
      List<MathSession> _items =
          content.map((e) => MathSession.fromJson(e)).toList();
      return AnalyticsData(_items);
    } else {
      return AnalyticsData([]);
    }
  }

  Map<String, dynamic> toJson() => _analyticsDataToJson(this);
}

Map<String, dynamic> _analyticsDataToJson(AnalyticsData instance) {
  List<Map<String, dynamic>> items =
      instance.content.map((e) => e.toJson()).toList();

  return <String, dynamic>{"content": instance.content};
}
