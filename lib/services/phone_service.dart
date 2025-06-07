import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneService {
  static Future<String?> getPhoneNumberByName(String name) async {
    // Request contacts permission
    if (!await FlutterContacts.requestPermission()) return null;

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
    );
    for (final contact in contacts) {
      if (contact.displayName.toLowerCase().contains(name.toLowerCase()) &&
          contact.phones.isNotEmpty) {
        return contact.phones.first.number;
      }
    }
    return null;
  }

  static Future<String> callByName(String name) async {
    final number = await getPhoneNumberByName(name);
    if (number == null) return "I couldn't find $name in your contacts.";
    return await makeCall(number);
  }

  static Future<String> smsByName(String name, String message) async {
    final number = await getPhoneNumberByName(name);
    if (number == null) return "I couldn't find $name in your contacts.";
    return await sendSMS(phone: number, message: message);
  }

  static Future<String> sendSMS({required String phone, required String message}) async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
      if (!status.isGranted) {
        return 'SMS permission denied!';
      }
    }
    final Uri uri = Uri(scheme: 'sms', path: phone, queryParameters: {'body': message});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return 'Opening SMS app for $phone...';
    }
    return 'Could not open SMS app.';
  }

  static Future<String> makeCall(String phone) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        return 'Call permission denied!';
      }
    }
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return 'Calling $phone...';
    }
    return 'Could not make the call.';
  }
}
