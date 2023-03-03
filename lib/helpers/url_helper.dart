import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<bool> loadUrl(Uri url) async {
    var canLaunch = await canLaunchUrl(url);
    if (canLaunch) {
      launchUrl(url);
      return true;
    } else {
      return false;
    }
  }
}
