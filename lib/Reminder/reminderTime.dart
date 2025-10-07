import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_application/Reminder/ReminderScreen.dart';
import 'package:personal_application/Reminder_Call/reminder_model.dart';
import 'package:personal_application/Reminder_Call/reminder_service.dart';

class TimePicker extends StatefulWidget {
  final Function(String) onTimeChanged;
  final String? initialTime;

  const TimePicker({super.key, required this.onTimeChanged, this.initialTime});

  @override
  State<TimePicker> createState() => _TimePicker();
}

class _TimePicker extends State<TimePicker> {
  String selectedTime = "AM";
  int selectedHour = 1;
  int selectedMinute = 0;

  final List<String> amPmList = ['AM', 'PM'];
  final List<int> hourList = List.generate(12, (index) => index + 1);
  final List<int> minuteList = List.generate(60, (index) => index);

  @override
  void initState() {
    super.initState();

    if (widget.initialTime != null) {
      _parseInitialTime(widget.initialTime!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTime();
    });
  }

  void _parseInitialTime(String timeString) {
    try {
      final parts = timeString.split(' ');
      if (parts.length == 2) {
        selectedTime = parts[1];

        final timeParts = parts[0].split(':');
        if (timeParts.length == 2) {
          selectedHour = int.parse(timeParts[0]);
          selectedMinute = int.parse(timeParts[1]);
        }
      }
    } catch (e) {
      print('Failed to parse initial time: $e');
    }
  }

  void _updateTime() {
    String formattedTime =
        "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} $selectedTime";
    widget.onTimeChanged(formattedTime);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: LinearGradient(
          colors: [Color(0xFF9900FF), Color(0xFF413243), Color(0xFFFF00AA)],
        ),
        strokeWidth: 2,
        radius: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9).withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: _TimePickerScreen(),
          ),
        ),
      ),
    );
  }

  Widget _TimePickerScreen() {
    return Column(
      children: [
        Text(
          'Select Time',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 70,
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  itemExtent: 45,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedTime == "AM" ? 0 : 1,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedTime = amPmList[index];
                      _updateTime();
                    });
                  },
                  children: amPmList
                      .map(
                        (e) => Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Text(
                ':',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 70,
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  itemExtent: 45,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedHour - 1,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedHour = hourList[index];
                      _updateTime();
                    });
                  },
                  children: hourList
                      .map(
                        (e) => Center(
                          child: Text(
                            e.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Text(
                ':',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 70,
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  itemExtent: 45,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedMinute,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedMinute = minuteList[index];
                      _updateTime();
                    });
                  },
                  children: minuteList
                      .map(
                        (e) => Center(
                          child: Text(
                            e.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SetUp extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedTime;
  final Reminder? existingReminder;

  const SetUp({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    this.existingReminder,
  });

  @override
  State<SetUp> createState() => _SetUp();
}

class _SetUp extends State<SetUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();

  String? _selectedTimeOfDay;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      _nameController.text = widget.existingReminder!.name;
      _placeController.text = widget.existingReminder!.location;
      _reminderController.text = widget.existingReminder!.reminderText;
      _selectedTimeOfDay = widget.existingReminder!.timeOfDay;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _reminderController.dispose();
    super.dispose();
  }

  Future<void> _saveReminder() async {
    if (_nameController.text.isEmpty ||
        _reminderController.text.isEmpty ||
        _placeController.text.isEmpty ||
        _selectedTimeOfDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final timeFrom = widget.selectedTime;
      final timeTo = _generateEndTime(widget.selectedTime);

      final reminder = Reminder(
        id: widget.existingReminder?.id ?? '',
        name: _nameController.text.trim(),
        reminderText: _reminderController.text.trim(),
        timeFrom: timeFrom,
        timeTo: timeTo,
        location: _placeController.text.trim(),
        date: widget.selectedDate,
        timeOfDay: _selectedTimeOfDay!,
        createdAt: widget.existingReminder?.createdAt ?? DateTime.now(),
      );

      if (widget.existingReminder != null) {
        await ReminderService.updateReminder(
          widget.existingReminder!.id,
          reminder,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await ReminderService.saveReminder(reminder);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pushReplacementNamed(context, Navigation.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to ${widget.existingReminder != null ? 'update' : 'save'} reminder: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _generateEndTime(String startTime) {
    try {
      final parts = startTime.split(' ');
      final timePart = parts[0];
      final period = parts[1];

      final timeParts = timePart.split(':');
      int hour = int.parse(timeParts[0]);
      final minute = timeParts[1];

      hour = hour + 1;
      if (hour > 12) {
        hour = hour - 12;
        final newPeriod = period == 'AM' ? 'PM' : 'AM';
        return '$hour:$minute $newPeriod';
      }

      return '$hour:$minute $period';
    } catch (e) {
      return startTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: LinearGradient(
          colors: [Color(0xFF9900FF), Color(0xFF413243), Color(0xFFFF00AA)],
        ),
        strokeWidth: 2,
        radius: 36,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 380,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9).withOpacity(0.15),
              borderRadius: BorderRadius.circular(36),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: SetupScreen(),
          ),
        ),
      ),
    );
  }

  Widget SetupScreen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existingReminder != null ? 'Edit Reminder' : 'Set it Up!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Divider(color: Colors.white70),
            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xFF9900FF), Color(0xFF666666)],
                ),
              ),
              padding: EdgeInsets.all(1.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Name...",
                    hintStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [Color(0xFF9900FF), Color(0xFF666666)],
                      ),
                    ),
                    padding: EdgeInsets.all(1.5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black),
                        value: _selectedTimeOfDay,
                        decoration: InputDecoration(
                          hintText: "To What Time...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                        ),
                        items: ["Morning", "Afternoon", "Evening"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedTimeOfDay = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [Color(0xFF9900FF), Color(0xFF666666)],
                      ),
                    ),
                    padding: EdgeInsets.all(1.5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _placeController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Place...",
                          hintStyle: TextStyle(color: Colors.black54),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: [Color(0xFF9900FF), Color(0xFF666666)],
                ),
              ),
              padding: EdgeInsets.all(1.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _reminderController,
                  maxLines: 3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Reminder...",
                    hintStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
              ),
              onPressed: _isLoading ? null : _saveReminder,
              child: _isLoading
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      widget.existingReminder != null
                          ? "Update Reminder"
                          : "Save Reminder",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Remindertime extends StatefulWidget {
  static const String id = "Remindertime";
  final DateTime? selectedDate;
  final Reminder? existingReminder;

  const Remindertime({super.key, this.selectedDate, this.existingReminder});

  @override
  State<Remindertime> createState() => _Remindertime();
}

class _Remindertime extends State<Remindertime> {
  String selectedTime = "1:00 AM";

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      selectedTime = widget.existingReminder!.timeFrom;
    }
  }

  void _updateSelectedTime(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = widget.selectedDate ?? DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF06011D),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/ReminderScreen.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SafeArea(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Navigation.id,
                          );
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SafeArea(
                      child: Text(
                        widget.existingReminder != null
                            ? 'Edit Your Reminder'
                            : 'Make Your Reminder',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50),

                TimePicker(
                  onTimeChanged: _updateSelectedTime,
                  initialTime: widget.existingReminder?.timeFrom,
                ),
                SizedBox(height: 20),
                SetUp(
                  selectedDate: currentDate,
                  selectedTime: selectedTime,
                  existingReminder: widget.existingReminder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
