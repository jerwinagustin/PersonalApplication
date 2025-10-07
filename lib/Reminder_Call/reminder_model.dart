import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String id;
  final String name;
  final String reminderText;
  final String timeFrom;
  final String timeTo;
  final String location;
  final DateTime date;
  final String timeOfDay;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.name,
    required this.reminderText,
    required this.timeFrom,
    required this.timeTo,
    required this.location,
    required this.date,
    required this.timeOfDay,
    required this.createdAt,
  });

  factory Reminder.fromFirestore(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Reminder(
        id: doc.id,
        name: data['name'] ?? '',
        reminderText: data['reminderText'] ?? '',
        timeFrom: data['timeFrom'] ?? '',
        timeTo: data['timeTo'] ?? '',
        location: data['location'] ?? '',
        date: data['date'] != null
            ? (data['date'] as Timestamp).toDate()
            : DateTime.now(),
        timeOfDay: data['timeOfDay'] ?? '',
        createdAt: data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing reminder from Firestore: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toFirestore() {
    try {
      return {
        'name': name,
        'reminderText': reminderText,
        'timeFrom': timeFrom,
        'timeTo': timeTo,
        'location': location,
        'date': Timestamp.fromDate(date),
        'timeOfDay': timeOfDay,
        'createdAt': Timestamp.fromDate(createdAt),
      };
    } catch (e) {
      print('Error converting reminder to Firestore: $e');
      rethrow;
    }
  }

  String get formattedTimeRange => '$timeFrom - $timeTo';

  String get dateKey {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'Reminder(id: $id, name: $name, reminderText: $reminderText, timeRange: $formattedTimeRange, location: $location, date: $date, timeOfDay: $timeOfDay)';
  }
}
