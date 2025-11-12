import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_application/Reminder/reminderTime.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:personal_application/Reminder_Call/reminder_model.dart';
import 'package:personal_application/Reminder_Call/reminder_service.dart';
import 'package:personal_application/Notifications/notification_service.dart';

class ReminderScreen extends StatefulWidget {
  static const String id = 'ReminderScreen';
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  List<Reminder> reminders = [];
  bool isLoading = true;
  String? selectedReminderId;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() {
    if (selectedDay != null && ReminderService.isUserAuthenticated()) {
      ReminderService.getRemindersForDate(selectedDay!).listen(
        (reminderList) {
          setState(() {
            reminders = reminderList;
            isLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading reminders: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } else {
      setState(() {
        reminders = [];
        isLoading = false;
      });
    }
  }

  Future<void> _refreshReminders() async {
    setState(() {
      isLoading = true;
      selectedReminderId = null;
    });
    _loadReminders();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
      isLoading = true;
      selectedReminderId = null;
    });
    _loadReminders();
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF170B3F),
          title: Text(
            'Delete Reminder',
            style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
          ),
          content: Text(
            'Are you sure you want to delete "${reminder.reminderText}"?',
            style: TextStyle(color: Colors.white70, fontFamily: 'Inter'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ReminderService.deleteReminder(reminder.id);
        // Cancel any scheduled notifications for this reminder (best-effort)
        try {
          await NotificationService.cancelReminderNotifications(reminder.id);
        } catch (_) {
          // Ignore cancellation errors; deletion succeeded
        }
        setState(() {
          selectedReminderId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editReminder(Reminder reminder) {
    setState(() {
      selectedReminderId = null;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Remindertime(
          selectedDate: reminder.date,
          existingReminder: reminder,
        ),
      ),
    ).then((_) {
      _refreshReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06011D),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/ReminderScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshReminders,
            color: Colors.deepPurpleAccent,
            child: Scrollbar(
              thumbVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    'Calendar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Center(child: _buildCalendarCard()),

                  SizedBox(height: 15),
                  _buildReminderCard(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: LinearGradient(
          colors: [Color(0xFF9900FF), Color(0xFF413243), Color(0xFFFF00AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        strokeWidth: 2,
        radius: 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: _buildCalendar(),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TableCalendar(
        firstDay: DateTime.utc(1, 1, 1),
        lastDay: DateTime.utc(9999, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: _onDaySelected,
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black54,
              ),
            ],
          ),
          weekendTextStyle: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black54,
              ),
            ],
          ),
          outsideTextStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 16,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black38,
              ),
            ],
          ),
          todayDecoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black87,
              ),
            ],
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 28,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 28,
          ),
          leftChevronPadding: EdgeInsets.all(12),
          rightChevronPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildReminderCard() {
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: LinearGradient(
          colors: [Color(0xFF9900FF), Color(0xFF413243), Color(0xFFFF00AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        strokeWidth: 1.5,
        radius: 36,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Column(
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF03000F),
                        Color(0xFF050017),
                        Color(0xFF170B3F),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, color: Color(0xFFFFBB00), size: 8),
                      SizedBox(width: 10),
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(selectedDay!),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Remindertime(selectedDate: selectedDay),
                            ),
                          );
                          _refreshReminders();
                        },
                        icon: Icon(
                          Icons.more_horiz,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: isLoading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : reminders.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(height: 20),
                                  Icon(
                                    Icons.event_available_outlined,
                                    color: Colors.white60,
                                    size: 64,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'No reminders for this date',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Tap the ••• button to create your first reminder',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                ],
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: reminders.length,
                                separatorBuilder: (context, index) => Column(
                                  children: [
                                    SizedBox(height: 12),
                                    Divider(
                                      color: Color(0xFFBDBDBD),
                                      thickness: 2,
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                                itemBuilder: (context, index) {
                                  final reminder = reminders[index];
                                  final isSelected =
                                      selectedReminderId == reminder.id;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedReminderId = isSelected
                                            ? null
                                            : reminder.id;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  reminder.name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          _editReminder(
                                                            reminder,
                                                          ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                          10,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue
                                                              .withOpacity(
                                                                0.15,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                          color:
                                                              Colors.blue[300],
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          _deleteReminder(
                                                            reminder,
                                                          ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                          10,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red
                                                              .withOpacity(
                                                                0.15,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.red
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Colors.red[300],
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),

                                          SizedBox(height: 10),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  reminder.reminderText,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 8),

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    reminder.formattedTimeRange,
                                                    style: TextStyle(
                                                      color: Color(0xFFBDBDBD),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    reminder.location,
                                                    style: TextStyle(
                                                      color: Color(0xFFBDBDBD),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final double radius;

  GradientBorderPainter({
    required this.gradient,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
