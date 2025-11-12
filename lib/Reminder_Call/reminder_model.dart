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

  factory Reminder.fromRealtime(String id, Map<String, dynamic> data) {
    final dateMillis = data['date'] is int
        ? data['date'] as int
        : int.tryParse('${data['date']}') ?? DateTime.now().millisecondsSinceEpoch;
    final createdMillis = data['createdAt'] is int
        ? data['createdAt'] as int
        : int.tryParse('${data['createdAt']}') ?? DateTime.now().millisecondsSinceEpoch;

    return Reminder(
      id: id,
      name: (data['name'] ?? '') as String,
      reminderText: (data['reminderText'] ?? '') as String,
      timeFrom: (data['timeFrom'] ?? '') as String,
      timeTo: (data['timeTo'] ?? '') as String,
      location: (data['location'] ?? '') as String,
      date: DateTime.fromMillisecondsSinceEpoch(dateMillis),
      timeOfDay: (data['timeOfDay'] ?? '') as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMillis),
    );
  }

  Map<String, dynamic> toRealtime() {
    return {
      'name': name,
      'reminderText': reminderText,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'location': location,
      'date': date.millisecondsSinceEpoch,
      'timeOfDay': timeOfDay,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
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
