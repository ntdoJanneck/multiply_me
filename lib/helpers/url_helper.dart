import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<bool> loadUrl(Uri url) async {
    try {
      await launchUrl(url);
      return true;
    } catch (e) {
      return false;
    }
  }
}
