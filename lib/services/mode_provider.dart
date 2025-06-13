import 'package:flutter/material.dart';

class ModeProvider with ChangeNotifier {
  bool _isChatBotMode = false;

  bool get isChatBotMode => _isChatBotMode;

  void setChatBotMode(bool value) {
    _isChatBotMode = value;
    notifyListeners();
  }
}