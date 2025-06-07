import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncherService {
  static Future<String> openAppByPackage(String packageName, String appName) async {
    bool isInstalled = await DeviceApps.isAppInstalled(packageName);
    if (isInstalled) {
      DeviceApps.openApp(packageName);
      return "Opening $appName.";
    }
    return "$appName is not installed on your device.";
  }

  // Try launching Android calculator (may need to change package for some phones)
  static Future<String> openCalculator() async {
    const packageNames = [
      /*"com.android.calculator2", // Stock Android
      "com.sec.android.app.calculator", // Samsung
      "com.miui.calculator", // Xiaomi
      "com.oneplus.calculator",*/ // OnePlus
      "com.transsion.calculator"
      // add more as needed
    ];
    for (var packageName in packageNames) {
      bool isInstalled = await DeviceApps.isAppInstalled(packageName);
      if (isInstalled) {
        DeviceApps.openApp(packageName);
        return "Opening calculator.";
      }
    }
    return "Calculator app not found on your device.";
  }


  // Play a YouTube video by video ID or search
  static Future<String> playYouTubeVideo(String query) async {
    // If query looks like a YouTube video URL or ID, launch it directly
    String url;
    if (query.contains('youtube.com') || query.contains('youtu.be')) {
      url = query;
    } else {
      // Otherwise, search for it
      url = 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}';
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return 'Playing YouTube: $query';
    }
    return "Could not open YouTube.";
  }
}
