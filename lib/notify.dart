import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notif {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static Future<void> init() async {
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(const InitializationSettings(android: android));
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  static AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  /// Asks for the notification permission (Android 13+). Returns true when allowed.
  static Future<bool> requestPermission() async {
    if (!_ready) return false;
    try {
      final ok = await _android?.requestNotificationsPermission();
      return ok ?? true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> cancelAll() async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }

  /// Schedules one notification per item. Each item is (title, body, UTC time).
  static Future<void> scheduleAll(List<(String, String, DateTime)> items) async {
    if (!_ready) return;
    await cancelAll();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_times',
        'Prayer times',
        channelDescription: 'Prayer time alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    final now = DateTime.now().toUtc();
    var id = 100;
    for (final it in items) {
      if (!it.$3.isAfter(now)) continue;
      final when = tz.TZDateTime.from(it.$3, tz.UTC);
      try {
        await _plugin.zonedSchedule(id, it.$1, it.$2, when, details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
      } on PlatformException {
        // Exact alarms not permitted on this phone: fall back to an inexact alarm.
        try {
          await _plugin.zonedSchedule(id, it.$1, it.$2, when, details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
        } catch (_) {}
      } catch (_) {}
      id++;
    }
  }
}
