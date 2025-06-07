import 'package:url_launcher/url_launcher.dart';

class WebService {
  static Future<String> openWebsite(String url) async {
    // Add https:// if not present
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return 'Opening $url';
    } else {
      return 'Could not open $url';
    }
  }
}
