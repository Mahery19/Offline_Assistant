import 'package:wifi_iot/wifi_iot.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class DeviceControlService {
  // Wi-Fi (now matches Bluetooth/Airplane mode approach)
  static Future<String> setWifi(bool enable) async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.WIFI_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
      return 'Opening Wi-Fi settings. Please turn Wi-Fi ${enable ? "on" : "off"} manually.';
    } catch (e) {
      return "Couldn't open Wi-Fi settings.";
    }
  }

  // Bluetooth
  static Future<String> setBluetooth(bool enable) async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.BLUETOOTH_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
      return 'Opening Bluetooth settings. Please turn Bluetooth ${enable ? "on" : "off"} manually.';
    } catch (e) {
      return "Couldn't open Bluetooth settings.";
    }
  }

  // Airplane mode - can only open settings!
  static Future<String> openAirplaneModeSettings() async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.AIRPLANE_MODE_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
      return 'Opening Airplane mode settings. Please toggle manually.';
    } catch (e) {
      return "Couldn't open Airplane Mode settings.";
    }
  }
}
