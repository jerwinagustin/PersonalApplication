import 'package:flutter/material.dart';
import 'package:personal_application/Auth/Authservice.dart';
import 'package:intl/intl.dart';

class Diary extends StatefulWidget {
  const Diary({super.key});

  @override
  State<Diary> createState() => _Diary();
}

class _Diary extends State<Diary> {
  DateTime selectedDate = DateTime.now();

  String getUserGreeting() {
    final user = authService.value.currentUser;
    if (user != null) {
      final displayName =
          user.displayName ?? user.email?.split('@')[0] ?? 'User';
      return 'Good Afternoon, $displayName';
    }
    return 'Good Afternoon, User';
  }

  List<DateTime> getNextDays(int daysCount) {
    return List.generate(daysCount, (index) {
      return DateTime.now().add(Duration(days: index));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final days = getNextDays(7);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Container(color: Color(0xFF07011F)),
              Opacity(
                opacity: 0.2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/Phone.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    SafeArea(
                      child: Text(
                        getUserGreeting(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),

                    SizedBox(height: 21),

                    SafeArea(
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 95,
                        decoration: BoxDecoration(
                          color: Color(0xFF170B3F),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 11,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'images/Happy.png',
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2),
                                  Text(
                                    'Your mood is good',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Keep it in your mood to be a good \nperson',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 33),

                    Row(
                      children: [
                        Text(
                          'Your Diary',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),

                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_horiz),
                          color: Colors.white,
                        ),
                      ],
                    ),

                    SizedBox(height: 7),

                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          final date = days[index];
                          final isSelected =
                              date.day == selectedDate.day &&
                              date.month == selectedDate.month &&
                              date.year == selectedDate.year;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              width: 50,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Color(0xFF3B1B9C)
                                    : Color(0xFF150A3A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat.MMMM()
                                        .format(date)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: isSelected
                                          ? Colors.white
                                          : Color(0xFFBDBDBD),
                                      fontSize: 10,
                                    ),
                                  ),

                                  Text(
                                    date.day.toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  ),

                                  Text(
                                    DateFormat.E().format(date),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      color: isSelected
                                          ? Colors.white
                                          : Color(0xFFBDBDBD),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
