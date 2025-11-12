import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reminder_model.dart';

class ReminderService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static String? get currentUserId => _auth.currentUser?.uid;

  static DatabaseReference _remindersRef() {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _database.ref('users/${currentUserId}/reminders');
  }

  static Future<String> saveReminder(Reminder reminder) async {
    try {
      if (currentUserId == null) {
        try {
          await _auth.signInAnonymously();
          print('Signed in anonymously for reminders');
        } catch (authError) {
          throw Exception('Authentication failed: $authError');
        }
      }

      if (currentUserId == null) {
        throw Exception('User not authenticated. Please log in first.');
      }

      if (reminder.name.isEmpty || reminder.reminderText.isEmpty) {
        throw Exception('Reminder name and text cannot be empty');
      }

      final ref = _remindersRef().push();
      await ref.set(reminder.toRealtime());
      return ref.key ?? '';
    } catch (e) {
      print('Error saving reminder: $e');
      throw Exception('Failed to save reminder: $e');
    }
  }

  static Stream<List<Reminder>> getAllReminders() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    final query = _remindersRef().orderByChild('date');
    return query.onValue.map((event) {
      final snap = event.snapshot;
      final List<Reminder> reminders = [];
      if (snap.exists) {
        for (final child in snap.children) {
          final key = child.key;
          final value = child.value;
          if (key != null && value is Map) {
            final data = Map<String, dynamic>.from(value as Map);
            reminders.add(Reminder.fromRealtime(key, data));
          }
        }
      }
      reminders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return reminders;
    });
  }

  static Stream<List<Reminder>> getRemindersForDate(DateTime date) {
    if (currentUserId == null) {
      _auth
          .signInAnonymously()
          .then((_) {
            print('Signed in anonymously for reading reminders');
          })
          .catchError((error) {
            print('Anonymous sign in failed: $error');
            return null;
          });
      return Stream.value([]);
    }

    DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final start = startOfDay.millisecondsSinceEpoch;
    final end = endOfDay.millisecondsSinceEpoch;
    final query = _remindersRef().orderByChild('date').startAt(start).endAt(end);
    return query.onValue.map((event) {
      final snap = event.snapshot;
      final List<Reminder> reminders = [];
      if (snap.exists) {
        for (final child in snap.children) {
          final key = child.key;
          final value = child.value;
          if (key != null && value is Map) {
            final data = Map<String, dynamic>.from(value as Map);
            reminders.add(Reminder.fromRealtime(key, data));
          }
        }
      }
      reminders.sort((a, b) {
        int dateComparison = a.date.compareTo(b.date);
        if (dateComparison == 0) {
          return a.createdAt.compareTo(b.createdAt);
        }
        return dateComparison;
      });
      return reminders;
    });
  }

  static Future<void> updateReminder(
    String reminderId,
    Reminder reminder,
  ) async {
    try {
      await _remindersRef().child(reminderId).update(reminder.toRealtime());
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  static Future<void> deleteReminder(String reminderId) async {
    try {
      await _remindersRef().child(reminderId).remove();
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }

  static Future<Reminder?> getReminderById(String reminderId) async {
    try {
      final snap = await _remindersRef().child(reminderId).get();
      if (snap.exists && snap.value is Map) {
        final data = Map<String, dynamic>.from(snap.value as Map);
        return Reminder.fromRealtime(reminderId, data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get reminder: $e');
    }
  }

  static bool isUserAuthenticated() {
    return currentUserId != null;
  }
}
