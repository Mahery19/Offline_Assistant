import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomCommandProvider with ChangeNotifier {
  Map<String, String> _customCommands = {};

  Map<String, String> get customCommands => _customCommands;

  CustomCommandProvider() {
    _loadCommands();
  }

  Future<void> _loadCommands() async {
    final prefs = await SharedPreferences.getInstance();
    final mapString = prefs.getString('custom_commands');
    if (mapString != null) {
      // Decode as Map<String, String>
      _customCommands = Map<String, String>.from(
        Map<String, dynamic>.from(
          (mapString.isNotEmpty) ? Map<String, dynamic>.from(Uri.splitQueryString(mapString)) : {},
        ),
      );
      notifyListeners();
    }
  }

  Future<void> addCommand(String trigger, String action) async {
    _customCommands[trigger.toLowerCase()] = action;
    await _saveCommands();
    notifyListeners();
  }

  Future<void> removeCommand(String trigger) async {
    _customCommands.remove(trigger.toLowerCase());
    await _saveCommands();
    notifyListeners();
  }

  Future<void> _saveCommands() async {
    final prefs = await SharedPreferences.getInstance();
    // Store as query string for simplicity
    await prefs.setString('custom_commands', Uri(queryParameters: _customCommands).query);
  }
}
