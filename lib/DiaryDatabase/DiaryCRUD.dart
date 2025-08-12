import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNote({
    required String title,
    required String genre,
    required String note,
    DateTime? selectedDate,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Please log in first");
    }

    DateTime noteDate = selectedDate ?? DateTime.now();
    DateTime now = DateTime.now();

    String currentTime = _formatTime(now);

    DateTime timestampDate = DateTime(
      noteDate.year,
      noteDate.month,
      noteDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    await _firestore.collection('users').doc(user.uid).collection('notes').add({
      'title': title,
      'genre': genre,
      'note': note,
      'time': currentTime,
      'timestamp': Timestamp.fromDate(timestampDate),
      'dateOnly':
          '${noteDate.year}-${noteDate.month.toString().padLeft(2, '0')}-${noteDate.day.toString().padLeft(2, '0')}',
    });
  }

  Stream<QuerySnapshot> getNotesStreamForDate(DateTime selectedDate) {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Please log in first");
    }

    String dateString =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .where('dateOnly', isEqualTo: dateString)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getNotesStream() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Please log in first");
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> updateNote({
    required String docID,
    required String newNote,
    required String newTitle,
    required String newGenre,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Please log in first");
    }

    DateTime now = DateTime.now();
    String currentTime = _formatTime(now);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(docID)
        .update({
          'title': newTitle,
          'genre': newGenre,
          'note': newNote,
          'time': currentTime,
        });
  }

  Future<void> deleteNote(String docID) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Please log in first");
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(docID)
        .delete();
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return "$displayHour:${minute.toString().padLeft(2, '0')} $period";
  }
}
