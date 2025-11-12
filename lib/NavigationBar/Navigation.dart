import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_application/DiaryPage/Diary.dart';
import 'package:personal_application/DiaryPage/DiaryNote.dart';
import 'package:personal_application/Reminder/ReminderScreen.dart';
import 'package:personal_application/Weather/weatherScreen.dart';
import 'package:personal_application/LogoutPage/logout.dart';

class Navigation extends StatefulWidget {
  static const String id = 'Navigation';

  const Navigation({super.key});

  @override
  State<Navigation> createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  int select = 0;
  DateTime? currentBackPressTime;

  static const List<Widget> pages = <Widget>[
    Diary(),
    Weatherscreen(),
    ReminderScreen(),
    Logout(),
  ];

  void NavTap(int index) {
    setState(() {
      select = index;
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF4E2FB8),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldPop = await onWillPop();
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline_rounded),
                        label: 'Account',
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
                    Navigator.pushNamed(context, Diarynote.id);
                  },
                  backgroundColor: Color(0xFF4E2FB8),
                  shape: CircleBorder(),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              )
            : null,

        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
