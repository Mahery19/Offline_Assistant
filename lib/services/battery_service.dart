import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  static final Battery _battery = Battery();

  static Future<String> getBatteryLevel() async {
    try {
      final int level = await _battery.batteryLevel;
      return 'Battery level is $level percent.';
    } catch (e) {
      return 'Unable to read battery level.';
    }
  }
}
