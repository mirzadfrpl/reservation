import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/notification_helper.dart';

class DailyReminderProvider extends ChangeNotifier {
  static const String _dailyReminderKey = 'daily_reminder_status';
  late SharedPreferences _prefs;
  bool _isDailyReminderActive = false;
  final NotificationHelper _notificationHelper = NotificationHelper();

  bool get isDailyReminderActive => _isDailyReminderActive;

  DailyReminderProvider() {
    _loadDailyReminderStatus();
  }

  Future<void> _loadDailyReminderStatus() async {
    _prefs = await SharedPreferences.getInstance();
    _isDailyReminderActive = _prefs.getBool(_dailyReminderKey) ?? false;
    notifyListeners();
  }

  void toggleDailyReminder(bool value) async {
    _isDailyReminderActive = value;
    _prefs.setBool(_dailyReminderKey, value);
    if (value) {
      _notificationHelper.scheduleDailyNotification();
    } else {
      _notificationHelper.cancelNotification();
    }
    notifyListeners();
  }
}
