import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_application/Reminder/ReminderScreen.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

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
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: LinearGradient(
          colors: [Color(0xFF9900FF), Color(0xFF413243), Color(0xFFFF00AA)],
        ),
        strokeWidth: 2,
        radius: 0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9).withOpacity(0.15),
              borderRadius: BorderRadius.circular(0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: _TimePickerScreen(),
          ),
        ),
      ),
    );
  }

  Widget _TimePickerScreen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: selectedTime == "AM" ? 0 : 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedTime = amPmList[index];
                });
              },
              children: amPmList
                  .map(
                    (e) => Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            width: 60,
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: selectedHour - 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHour = hourList[index];
                });
              },
              children: hourList
                  .map(
                    (e) => Center(
                      child: Text(
                        e.toString().padLeft(2, '0'),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            width: 60,
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: selectedMinute,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMinute = minuteList[index];
                });
              },
              children: minuteList
                  .map(
                    (e) => Center(
                      child: Text(
                        e.toString().padLeft(2, '0'),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SetUp extends StatefulWidget {
  const SetUp({super.key});

  @override
  State<SetUp> createState() => _SetUp();
}

class _SetUp extends State<SetUp> {
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
              'Set it Up!',
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
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Name...",
                    hintStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                        decoration: InputDecoration(
                          hintText: "To What Time...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        items: ["Morning", "Afternoon", "Evening"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) {},
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
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Place...",
                          hintStyle: TextStyle(color: Colors.black54),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            TextField(
              maxLines: 3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Reminder...",
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Save Reminder",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
  const Remindertime({super.key});

  @override
  State<Remindertime> createState() => _Remindertime();
}

class _Remindertime extends State<Remindertime> {
  @override
  Widget build(BuildContext context) {
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
                        'Make Your Reminder',
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

                TimePicker(),
                SizedBox(height: 20),
                SetUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
