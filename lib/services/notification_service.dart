import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  // Call this at app start (already in your main.dart)
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notifications.initialize(initSettings);
  }

  /// Opens the system settings page for exact alarms, Android 12+
  static Future<void> openExactAlarmSettings() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    }
  }

  /// Schedules a reminder at the specified [dateTime] with [message]
  static Future<String> scheduleReminder({
    required String message,
    required DateTime dateTime,
    bool requireExact = true,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Scheduled reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notifDetails = NotificationDetails(android: androidDetails);

    final tzDateTime = tz.TZDateTime.from(dateTime, tz.local);

    try {
      await _notifications.zonedSchedule(
        dateTime.hashCode, // id
        'Reminder',
        message,
        tzDateTime,
        notifDetails,
        androidScheduleMode: requireExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexact,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      return 'Reminder set for ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted' && requireExact) {
        // Ask the user to enable the permission
        await openExactAlarmSettings();
        return 'Please enable "Schedule exact alarms" for this app in system settings, then try again.';
      } else {
        // Other error, fallback to inexact schedule if desired
        if (requireExact) {
          // Try inexact as fallback
          return await scheduleReminder(
              message: message, dateTime: dateTime, requireExact: false);
        } else {
          return 'Failed to set reminder: ${e.message ?? e.code}';
        }
      }
    } catch (e) {
      return 'Failed to set reminder: $e';
    }
  }
}
