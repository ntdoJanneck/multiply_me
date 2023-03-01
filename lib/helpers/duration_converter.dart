library duration_converter;

class DurationConverter {
  /// Converts a timestamp with the format HH:MM:ss.mmmmmm to a duration.
  static Duration toDuration(String isoString) {
    // regexr.com/6e1l7
    RegExp regex = RegExp(r"(([0-9])?[0-9]):[0-9][0-9]:[0-9][0-9].[0-9]{6}");

    if (regex.hasMatch(isoString)) {
      RegExp stringSplitRegex = RegExp(r"[:.]");
      var splitString = isoString.split(stringSplitRegex);

      int hours = int.parse(splitString[0]);
      int minutes = int.parse(splitString[1]);
      int seconds = int.parse(splitString[2]);
      int microseconds = int.parse(splitString[3]);

      Duration res = Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          microseconds: microseconds);

      return res;
    } else {
      throw FormatException(
          "Received string '$isoString' doesnt match expected Format",
          isoString);
    }
  }
}
