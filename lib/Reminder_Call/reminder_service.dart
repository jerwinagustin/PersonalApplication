import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reminder_model.dart';

class ReminderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get currentUserId => _auth.currentUser?.uid;

  static CollectionReference get _remindersCollection {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('reminders');
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

      final collection = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('reminders');

      DocumentReference docRef = await collection.add(reminder.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error saving reminder: $e');
      throw Exception('Failed to save reminder: $e');
    }
  }

  static Stream<List<Reminder>> getAllReminders() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _remindersCollection
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
          List<Reminder> reminders = snapshot.docs
              .map((doc) => Reminder.fromFirestore(doc))
              .toList();
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

    return _remindersCollection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
          List<Reminder> reminders = snapshot.docs
              .map((doc) => Reminder.fromFirestore(doc))
              .toList();
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
      await _remindersCollection.doc(reminderId).update(reminder.toFirestore());
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  static Future<void> deleteReminder(String reminderId) async {
    try {
      await _remindersCollection.doc(reminderId).delete();
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }

  static Future<Reminder?> getReminderById(String reminderId) async {
    try {
      DocumentSnapshot doc = await _remindersCollection.doc(reminderId).get();
      if (doc.exists) {
        return Reminder.fromFirestore(doc);
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
