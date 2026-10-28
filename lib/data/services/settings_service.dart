import 'package:flutter/foundation.dart';

/// Қолданба параметрлері (қараңғы тақырып, хабарландырулар).
class SettingsService extends ChangeNotifier {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  bool _darkMode = false;
  bool _notifications = true;

  bool get darkMode => _darkMode;
  bool get notifications => _notifications;

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notifications = value;
    notifyListeners();
  }
}
