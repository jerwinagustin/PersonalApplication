import 'package:flutter/material.dart';
import 'package:personal_application/DiaryPage/Diary.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  int select = 0;

  static const List<Widget> pages = <Widget>[
    Diary(),
    Center(child: Text('Weather Screen')),
    Center(child: Text('Reminder Screen')),
  ];

  void NavTap(int index) {
    setState(() {
      select = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[select],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xFF03000F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Diary'),
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
    );
  }
}
