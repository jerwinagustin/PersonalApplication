import 'package:flutter/material.dart';

class Reminderscreen extends StatefulWidget {
  static const String id = 'Reminderscreen';
  const Reminderscreen({super.key});

  @override
  State<Reminderscreen> createState() => _Reminderscreen();
}

class _Reminderscreen extends State<Reminderscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06011D),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/CalendarBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
