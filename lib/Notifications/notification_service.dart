import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:personal_application/Reminder_Call/reminder_model.dart';

// Top-level background handler for notification actions
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  final String? payload = response.payload;
  final String? actionId = response.actionId;
  if (actionId == NotificationService._actionMarkDone && payload != null) {
    await NotificationService.cancelReminderNotifications(payload);
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'reminder_channel';
  static const String _channelName = 'Reminders';
  static const String _channelDescription = 'Reminder notifications and alarms';

  // Action identifiers
  static const String _actionMarkDone = 'MARK_DONE';

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Configure timezone to device local
    try {
      tz.initializeTimeZones();
      final dynamic tzInfoOrString = await FlutterTimezone.getLocalTimezone();
      String localTimeZone;
      if (tzInfoOrString is String) {
        localTimeZone = tzInfoOrString;
      } else {
        final dynamic info = tzInfoOrString;
        String? id;
        try {
          id = info.ianaName as String?; // flutter_timezone >=5
        } catch (_) {}
        id ??= (() {
          try {
            return info.name as String?; // fallback to name if provided
          } catch (_) {
            return null;
          }
        })();
        localTimeZone = id ?? 'UTC';
      }
      tz.setLocalLocation(tz.getLocation(localTimeZone));
    } catch (e) {
      // Fallback: at least have timezones initialized
      tz.initializeTimeZones();
    }

    // Android init settings
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS categories with a Mark Done action
    final DarwinNotificationCategory darwinCategory = DarwinNotificationCategory(
      'REMINDER_CATEGORY',
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain(
          _actionMarkDone,
          'Mark Done',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{},
    );

    final DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: <DarwinNotificationCategory>[darwinCategory],
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
      macOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String? payload = response.payload;
        final String? actionId = response.actionId;
        if (actionId == _actionMarkDone && payload != null) {
          await cancelReminderNotifications(payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Android 13+ runtime permission
    try {
      final androidSpecific = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidSpecific?.requestNotificationsPermission();
      await androidSpecific?.requestExactAlarmsPermission();
    } catch (_) {}

    _initialized = true;
  }

  // Background action handler must be a top-level function with entry-point annotation
  // See: https://pub.dev/packages/flutter_local_notifications
  

  static AndroidNotificationDetails _androidDetails({bool insistent = false}) {
    // FLAG_INSISTENT = 0x00000004
    final Int32List? flags = insistent ? Int32List.fromList([4]) : null;
    return AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 500, 500, 500, 800]),
      ticker: 'Reminder Alert',
      fullScreenIntent: true,
      additionalFlags: flags,
      actions: const <AndroidNotificationAction>[
        AndroidNotificationAction(
          _actionMarkDone,
          'Mark Done',
          showsUserInterface: true,
        ),
      ],
    );
  }

  static const DarwinNotificationDetails _iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    categoryIdentifier: 'REMINDER_CATEGORY',
  );

  static NotificationDetails _details({bool insistent = false}) {
    return NotificationDetails(
      android: _androidDetails(insistent: insistent),
      iOS: _iosDetails,
      macOS: _iosDetails,
    );
  }

  static DateTime _composeDueDateTime(DateTime date, String timeFrom) {
    try {
      final parsed = DateFormat('h:mm a').parseStrict(timeFrom);
      return DateTime(date.year, date.month, date.day, parsed.hour, parsed.minute);
    } catch (_) {
      // If parsing fails, fallback to the start of selected date
      return DateTime(date.year, date.month, date.day, 0, 0);
    }
  }

  static int _baseIdFromReminderId(String reminderId) {
    // Ensure a stable, positive int from string id
    return reminderId.hashCode & 0x7fffffff;
  }

  static tz.TZDateTime _toTz(DateTime dt) {
    return tz.TZDateTime.from(dt, tz.local);
  }

  static Future<void> scheduleReminderNotifications(
    Reminder reminder,
    String reminderId,
  ) async {
    await initialize();

    final due = _composeDueDateTime(reminder.date, reminder.timeFrom);
    final now = DateTime.now();
    // Keep IDs safely within 32-bit range expected by native layers
    final baseId = _baseIdFromReminderId(reminderId) % 1000000; // <= 999,999

    // One hour left
    final oneHour = due.subtract(const Duration(hours: 1));
    if (oneHour.isAfter(now)) {
      try {
        await _plugin.zonedSchedule(
          baseId + 1,
          'Reminder in 1 hour',
          '${reminder.name} • ${reminder.reminderText}',
          _toTz(oneHour),
          _details(),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: reminderId,
        );
      } catch (_) {}
    }

    // 30 minutes left
    final thirty = due.subtract(const Duration(minutes: 30));
    if (thirty.isAfter(now)) {
      try {
        await _plugin.zonedSchedule(
          baseId + 2,
          'Reminder in 30 minutes',
          '${reminder.name} • ${reminder.reminderText}',
          _toTz(thirty),
          _details(),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: reminderId,
        );
      } catch (_) {}
    }

    // Time's up (insistent buzz on Android; iOS/macOS normal sound)
    if (due.isAfter(now)) {
      try {
        await _plugin.zonedSchedule(
          baseId + 3,
          'Time’s up',
          '${reminder.name} • ${reminder.reminderText}',
          _toTz(due),
          _details(insistent: true),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: reminderId,
        );
      } catch (_) {}

      // iOS/macOS do not support insistent; schedule follow-up pings for 10 minutes
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        for (int i = 1; i <= 10; i++) {
          final followUp = due.add(Duration(minutes: i));
          try {
            await _plugin.zonedSchedule(
              baseId + 100 + i,
              'Reminder pending',
              'Tap "Mark Done" to stop',
              _toTz(followUp),
              _details(),
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              payload: reminderId,
            );
          } catch (_) {}
        }
      }
    } else {
      // If due already passed, show immediate alert
      try {
        await _plugin.show(
          baseId + 3,
          'Time’s up',
          '${reminder.name} • ${reminder.reminderText}',
          _details(insistent: true),
          payload: reminderId,
        );
      } catch (_) {}
    }
  }

  // Helper to verify scheduling logic without invoking platform plugins
  static List<tz.TZDateTime> computeScheduleTimes(Reminder reminder, DateTime now) {
    final due = _composeDueDateTime(reminder.date, reminder.timeFrom);
    final times = <tz.TZDateTime>[];
    final oneHour = due.subtract(const Duration(hours: 1));
    final thirty = due.subtract(const Duration(minutes: 30));
    if (oneHour.isAfter(now)) times.add(_toTz(oneHour));
    if (thirty.isAfter(now)) times.add(_toTz(thirty));
    if (due.isAfter(now)) times.add(_toTz(due));
    return times;
  }

  static Future<void> cancelReminderNotifications(String reminderId) async {
    await initialize();
    final baseId = _baseIdFromReminderId(reminderId) % 1000000;
    // Cancel base ids and a range of possible follow-up ids
    await _plugin.cancel(baseId + 1);
    await _plugin.cancel(baseId + 2);
    await _plugin.cancel(baseId + 3);
    for (int i = 1; i <= 300; i++) {
      await _plugin.cancel(baseId + 100 + i);
    }
  }
}