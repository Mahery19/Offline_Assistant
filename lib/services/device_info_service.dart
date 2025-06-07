/* import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info2/system_info2.dart';
import 'package:disk_space/disk_space.dart';

class DeviceInfoService {
  static Future<String> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String os = Platform.operatingSystem;
    String osVersion = Platform.operatingSystemVersion;

    // Android specific info
    String model = '', manufacturer = '', androidVersion = '';
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      model = androidInfo.model ?? '';
      manufacturer = androidInfo.manufacturer ?? '';
      androidVersion = androidInfo.version.release ?? '';
    }

    // Storage info
    double? totalDisk = await DiskSpace.getTotalDiskSpace;
    double? freeDisk = await DiskSpace.getFreeDiskSpace;

    // RAM info (system_info2)
    int totalRam = SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024);
    int freeRam = SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024);

    return
      "Device: $manufacturer $model\n"
      "OS: Android $androidVersion\n"
      "Total Storage: ${totalDisk?.toStringAsFixed(1) ?? 'unknown'} GB\n"
      "Free Storage: ${freeDisk?.toStringAsFixed(1) ?? 'unknown'} GB\n"
      "Total RAM: $totalRam MB\n"
      "Free RAM: $freeRam MB";
  }
}
*/