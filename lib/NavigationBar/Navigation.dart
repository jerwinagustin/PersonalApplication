import 'package:flutter/material.dart';
import 'package:personal_application/DiaryPage/Diary.dart';
import 'package:personal_application/DiaryPage/DiaryNote.dart';
import 'package:personal_application/Reminder/ReminderScreen.dart';
import 'package:personal_application/Weather/weatherScreen.dart';

class Navigation extends StatefulWidget {
  static const String id = 'Navigation';

  const Navigation({super.key});

  @override
  State<Navigation> createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  int select = 0;

  static const List<Widget> pages = <Widget>[
    Diary(),
    Weatherscreen(),
    Reminderscreen(),
  ];

  void NavTap(int index) {
    setState(() {
      select = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[select],

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),

              child: Container(
                height: 80,
                color: Color(0xFF03000F),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  unselectedItemColor: Color(0xFF58507C),
                  selectedItemColor: Colors.white,
                  currentIndex: select,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  onTap: NavTap,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Diary',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.cloud),
                      label: 'Weather',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Reminder',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: select == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Diarynote.id);
                },
                backgroundColor: Color(0xFF4E2FB8),
                shape: CircleBorder(),
                child: Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
