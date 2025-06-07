import 'dart:math';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../services/flashlight_service.dart';
import '../services/app_launcher_service.dart';
import '../services/alarm_service.dart';
import '../services/notification_service.dart';
import '../services/phone_service.dart';
import '../services/device_control_service.dart';
import '../services/battery_service.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../services/audio_service.dart';
// import '../services/app_launcher_service.dart';
import '../services/web_service.dart';
// import '../services/device_info_service.dart';


// Map spoken app names to package names
const Map<String, String> appPackages = {
  "whatsapp": "com.whatsapp",
  "youtube": "com.google.android.youtube",
  "facebook": "com.facebook.katana",
  // "instagram": "com.instagram.android",
  // "twitter": "com.twitter.android",
  "gmail": "com.google.android.gm",
  "chrome": "com.android.chrome",
  "messenger": "com.facebook.orca",
  "camera": "com.transsion.camera",
  "bible": "mg.itworks.bf" 
  // Add more as needed
};

class ActionHandler {
  static Future<String> handleCommand(String input) async {
    final alarmRegex = RegExp(r'set alarm (for )?(at )?(\d{1,2})(:| )?(\d{2})?');
    final lower = input.toLowerCase();

    /*if (lower.contains('device info') || lower.contains('system info') || lower.contains('storage') || lower.contains('ram')) {
      return await DeviceInfoService.getDeviceInfo();
    }*/

    // "open [website]"
    final webRegex = RegExp(r'open (.+\.[a-z]{2,})(\/\S*)?');
    if (webRegex.hasMatch(lower)) {
      final match = webRegex.firstMatch(lower)!;
      final domain = match.group(1)!;
      // Keep any path/extra if present
      final path = match.group(2) ?? '';
      return await WebService.openWebsite(domain + path);
    }

    // Play local song: "play song" or "play music"
    if (lower.startsWith('play song') || lower.startsWith('play music')) {
      // Example path, change as needed:
      const songPath = '/storage/emulated/0/Music/Malagasy_music/zandry_hamed.mp3'; // or .mp4
      return await AudioService.playLocalFile(songPath);
    }

    // Play YouTube video: "play youtube [query or URL]"
    final ytRegex = RegExp(r'play youtube (.+)');
    if (ytRegex.hasMatch(lower)) {
      final match = ytRegex.firstMatch(lower)!;
      final ytQuery = match.group(1)!.trim();
      return await AppLauncherService.playYouTubeVideo(ytQuery);
    }

    // Next track
    if (lower.contains('next music') || lower.contains('next song') || lower.contains('next track')) {
      return await AudioService.next();
    }

    // Previous track
    if (lower.contains('previous music') || lower.contains('back music') ||
        lower.contains('previous song') || lower.contains('back song') ||
        lower.contains('previous track') || lower.contains('back track')) {
      return await AudioService.previous();
    }

    // Pause: "pause music"
    if (lower.contains('pause music') || lower.contains('pause audio')) {
      return await AudioService.pause();
    }

    // Stop: "stop music"
    if (lower.contains('stop music') || lower.contains('stop audio')) {
      return await AudioService.stop();
    }

    // Weather
    if (lower.contains('weather') || lower.contains('temperature')) {
      return await WeatherService.getCurrentWeather();
    }

    // Location & GPS
    if (lower.contains('location') || lower.contains('where am i') || lower.contains('gps')) {
      return await LocationService.getCurrentLocation();
    }

    // Battery
    if (lower.contains('battery')) {
      return await BatteryService.getBatteryLevel();
    }

    // Wi-Fi commands
    if (lower.contains('turn on Wi-Fi') || lower.contains('enable Wi-Fi')) {
      return await DeviceControlService.setWifi(true);
    }
    if (lower.contains('turn off Wi-Fi') || lower.contains('disable Wi-Fi')) {
      return await DeviceControlService.setWifi(false);
    }

    // Bluetooth commands
    if (lower.contains('turn on bluetooth') || lower.contains('enable bluetooth')) {
      return await DeviceControlService.setBluetooth(true);
    }
    if (lower.contains('turn off bluetooth') || lower.contains('disable bluetooth')) {
      return await DeviceControlService.setBluetooth(false);
    }

    // Airplane mode commands
    if (lower.contains('turn on airplane mode') || lower.contains('enable airplane mode') ||
        lower.contains('airplane mode')) {
      return await DeviceControlService.openAirplaneModeSettings();
    }


    // "call [name or number]"
    final callNameRegex = RegExp(r'call ([a-zA-Z ]+)');
    if (callNameRegex.hasMatch(lower)) {
      final match = callNameRegex.firstMatch(lower)!;
      final name = match.group(1)!.trim();
      // If it's digits, treat as number; if letters, look up contact
      if (RegExp(r'^\d+$').hasMatch(name)) {
        return await PhoneService.makeCall(name);
      } else {
        return await PhoneService.callByName(name);
      }
    }

    // "send sms to [name or number] [message]"
    final smsNameRegex = RegExp(r'send sms to ([a-zA-Z0-9 ]+) (.+)');
    if (smsNameRegex.hasMatch(lower)) {
      final match = smsNameRegex.firstMatch(lower)!;
      final to = match.group(1)!.trim();
      final message = match.group(2)!;
      if (RegExp(r'^\d+$').hasMatch(to)) {
        return await PhoneService.sendSMS(phone: to, message: message);
      } else {
        return await PhoneService.smsByName(to, message);
      }
    }

    // Open app command: "open whatsapp", "open youtube", etc.
    if (alarmRegex.hasMatch(lower)) {
      final match = alarmRegex.firstMatch(lower)!;
      final hour = int.parse(match.group(3)!);
      final minute = match.group(5) != null ? int.parse(match.group(5)!) : 0;
      return await AlarmService.setAlarm(hour: hour, minute: minute);
    }

    if (lower.startsWith('open ')) {
      final appName = lower.replaceFirst('open ', '').trim();
      if (appPackages.containsKey(appName)) {
        return await AppLauncherService.openAppByPackage(
          appPackages[appName]!,
          _capitalize(appName),
        );
      }
      return "I don't know how to open $appName yet.";
    }

    // Reminder
    final reminderRegex = RegExp(r'remind me to (.+) at (\d{1,2})(:| )?(\d{2})?');
    if (reminderRegex.hasMatch(lower)) {
      final match = reminderRegex.firstMatch(lower)!;
      final task = match.group(1)!;
      final hour = int.parse(match.group(2)!);
      final minute = match.group(4) != null ? int.parse(match.group(4)!) : 0;
      final now = DateTime.now();
      final reminderTime = DateTime(now.year, now.month, now.day, hour, minute);
      return await NotificationService.scheduleReminder(message: task, dateTime: reminderTime);
    }

    if (lower.contains('hello') || (lower.contains('hi'))) {
      return 'Hello! How can I help you?';
    } else if (lower.contains('time')) {
      final now = DateTime.now();
      return 'Current time is ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    } else if (lower.contains('date')) {
      final now = DateTime.now();
      return 'Today is ${now.year}-${now.month}-${now.day}';
    } else if (lower.contains('your name')) {
      return "I'm your personal voice assistant!";
    } else if (lower.contains('bye')) {
      return 'Goodbye!';
    } else if (lower.contains('f*** you')) {
      return 'Fuck you too , mother fucker!';
    } else if (lower.contains('weather')) {
      return 'Sorry, I can only give you fake weather: It is always sunny and 22°C!';
    } else if (lower.contains('joke')) {
      return _getRandomJoke();
    } else if (lower.contains('flashlight on')) {
      FlashlightService.toggleFlashlight(true);
      return "Turning flashlight ON.";
    } else if (lower.contains('flashlight off')) {
      FlashlightService.toggleFlashlight(false);
      return "Turning flashlight OFF.";
    } else if (lower.contains('open calculator')) {
      AppLauncherService.openCalculator();
      return "Opening calculator.";
    } else if (lower.startsWith('calculate')) {
      final expression = lower.replaceFirst('calculate', '').trim();
      try {
        final result = _simpleCalculate(expression);
        return 'The result is $result';
      } catch (e) {
        return 'Sorry, I could not calculate that.';
      }
    }
    return "Sorry, I didn't understand. Please try again.";
  }

  static String _getRandomJoke() {
    final jokes = [
      "Why did the developer go broke? Because he used up all his cache.",
      "Why do Java developers wear glasses? Because they can't C#.",
      "Why did the computer show up at work late? It had a hard drive!",
      "Debugging: Removing the needles from the haystack.",
      "Why was the cell phone wearing glasses? Because it lost its contacts."
    ];
    final random = Random();
    return jokes[random.nextInt(jokes.length)];
  }

  static num _simpleCalculate(String expression) {
    // VERY basic implementation: only single operations like "5 + 3"
    expression = expression.replaceAll('x', '*');
    final parts = expression.split(RegExp(r'(\+|\-|\*|\/)'));
    if (parts.length == 2) {
      final num1 = num.parse(parts[0].trim());
      final op = expression.replaceAll(RegExp(r'[0-9\s]'), '');
      final num2 = num.parse(parts[1].trim());
      switch (op) {
        case '+':
          return num1 + num2;
        case '-':
          return num1 - num2;
        case '*':
          return num1 * num2;
        case '/':
          return num2 != 0 ? num1 / num2 : double.nan;
      }
    }
    throw Exception('Invalid expression');
  }

  static String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
}