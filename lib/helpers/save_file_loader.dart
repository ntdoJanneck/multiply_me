import 'dart:convert';

import 'package:multiply_me/classes/analytics_data.dart';
import 'package:multiply_me/classes/analytics_math_session.dart';
import "json_utils.dart";

class SaveFileLoader {
  static void saveNewSessionToAnalyticsData(MathSession session) async {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // STEPS:                                                                                                     //
    // - load the current saved list from path and extract content                                                //
    // - if file doesnt exist, create new list, otherwise base64 decode content                                   //
    // - if file content is not empty, decode JSON content to list and use that instead of creating a new list    //
    // - Add new Item to list if length < 100, otherwise add to index 99 and remove index 0                       //
    // - Generate JSON from the list                                                                              //
    // - Base64 encode JSON                                                                                       //
    // - Save Base64 Encoded JSON                                                                                 //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // STEP ONE: LOAD
    String fileContent = await JsonUtils.readJsonFile("session_data");

    // STEP TWO: BASE64 DECODE
    String jsonContent =
        (fileContent != "") ? utf8.decode(base64.decode(fileContent)) : "";

    // STEP THREE: JSON DECODE
    AnalyticsData decodedData;
    if (jsonContent != "") {
      var blah = jsonDecode(jsonContent);
      decodedData = AnalyticsData.fromJson(blah);
    } else {
      decodedData = AnalyticsData([]);
    }

    // STEP FOUR: ADD NEW ENTRY
    AnalyticsData newData = decodedData.addNewSession(session);

    // STEP FIVE: SAVE NEW DATA
    String json = jsonEncode(newData.toJson());
    JsonUtils.writeJsonFile(base64.encode(utf8.encode(json)), "session_data");
  }

  static Future<AnalyticsData> getAnalyticsData() async {
    // STEP ONE: LOAD
    String fileContent = await JsonUtils.readJsonFile("session_data");

    // STEP TWO: BASE64 DECODE
    String jsonContent =
        (fileContent != "") ? utf8.decode(base64.decode(fileContent)) : "";

    // STEP THREE: JSON DECODE
    AnalyticsData decodedData;
    if (jsonContent != "") {
      var blah = jsonDecode(jsonContent);
      decodedData = AnalyticsData.fromJson(blah);
    } else {
      decodedData = AnalyticsData([]);
    }

    return decodedData;
  }
}
