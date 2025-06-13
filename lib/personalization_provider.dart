import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalizationProvider with ChangeNotifier {
  String _assistantName = "Assistant";
  String _wakeWord = "hey assistant";
  String _responseStyle = "default"; // "friendly", "formal", etc.

  String get assistantName => _assistantName;
  String get wakeWord => _wakeWord;
  String get responseStyle => _responseStyle;

  PersonalizationProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _assistantName = prefs.getString('assistant_name') ?? "Assistant";
    _wakeWord = prefs.getString('wake_word') ?? "hey assistant";
    _responseStyle = prefs.getString('response_style') ?? "default";
    notifyListeners();
  }

  Future<void> setAssistantName(String name) async {
    _assistantName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('assistant_name', name);
    notifyListeners();
  }

  Future<void> setWakeWord(String word) async {
    _wakeWord = word;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wake_word', word);
    notifyListeners();
  }

  Future<void> setResponseStyle(String style) async {
    _responseStyle = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('response_style', style);
    notifyListeners();
  }
}
