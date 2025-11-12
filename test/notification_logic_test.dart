import 'package:flutter_test/flutter_test.dart';
import 'package:personal_application/Notifications/notification_service.dart';
import 'package:personal_application/Reminder_Call/reminder_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
  });

  test('computeScheduleTimes returns 1h, 30m, and due when in the future', () {
    final reminder = Reminder(
      id: 'abc123',
      name: 'Test',
      reminderText: 'Test reminder',
      timeFrom: '10:00 PM',
      timeTo: '11:00 PM',
      location: 'Home',
      date: DateTime(2030, 1, 1),
      timeOfDay: 'Evening',
      createdAt: DateTime(2030, 1, 1),
    );

    final now = DateTime(2030, 1, 1, 20, 0); // 8:00 PM
    final times = NotificationService.computeScheduleTimes(reminder, now);

    // Compose due time similarly to service
    final parsed = DateFormat('h:mm a').parseStrict(reminder.timeFrom);
    final dueLocal = tz.TZDateTime.from(
      DateTime(reminder.date.year, reminder.date.month, reminder.date.day, parsed.hour, parsed.minute),
      tz.local,
    );

    expect(times.length, 3);
    expect(dueLocal.difference(times[0]).inMinutes, 60);
    expect(dueLocal.difference(times[1]).inMinutes, 30);
    expect(dueLocal.difference(times[2]).inMinutes, 0);
  });

  test('computeScheduleTimes skips past intervals', () {
    final reminder = Reminder(
      id: 'abc123',
      name: 'Test',
      reminderText: 'Test reminder',
      timeFrom: '10:00 PM',
      timeTo: '11:00 PM',
      location: 'Home',
      date: DateTime(2030, 1, 1),
      timeOfDay: 'Evening',
      createdAt: DateTime(2030, 1, 1),
    );

    final now = DateTime(2030, 1, 1, 22, 5); // 10:05 PM
    final times = NotificationService.computeScheduleTimes(reminder, now);
    expect(times.isEmpty, true);
  });
}