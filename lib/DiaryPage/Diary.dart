import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_application/Auth/Authservice.dart';
import 'package:intl/intl.dart';
import 'package:personal_application/DiaryDatabase/DiaryCRUD.dart';
import 'package:personal_application/DiaryPage/Update_Delete.dart';

class DiaryCard extends StatefulWidget {
  final DateTime selectedDate;

  const DiaryCard({super.key, required this.selectedDate});

  @override
  State<DiaryCard> createState() => _DiaryCard();
}

class _DiaryCard extends State<DiaryCard> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final cardPadding = isTablet ? 20.0 : 16.0;
    final fontSize = isTablet ? 18.0 : 16.0;

    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService().getNotesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List allNotes = snapshot.data!.docs;

          String selectedDateString =
              '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';

          List notesList = allNotes.where((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return data['dateOnly'] == selectedDateString;
          }).toList();

          if (notesList.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 48,
                      color: Color(0xFF818181),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notes yet...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the + button to create your first note',
                      style: TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: isTablet ? 14.0 : 12.0,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = notesList[index];
              String docID = document.id;

              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String Title = data['title'] ?? 'No Title';
              String noteText = data['note'] ?? 'No Content';
              String Genre = data['genre'] ?? 'General';
              String Time = data['time'] ?? 'No Time';

              bool isNewest = index == 0;

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateDelete(
                            docID: docID,
                            title: Title,
                            genre: Genre,
                            note: noteText,
                            time: Time,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: isTablet ? 140 : 120,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF150A3A),
                        borderRadius: BorderRadius.circular(12),
                        border: isNewest
                            ? Border.all(color: Color(0xFFF5DA3C), width: 1)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    Title,
                                    style: TextStyle(
                                      color: isNewest
                                          ? Color(0xFFF5DA3C)
                                          : Colors.white,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isNewest)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5DA3C).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Color(0xFFF5DA3C),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(height: 12),

                            Flexible(
                              child: Text(
                                noteText,
                                style: TextStyle(
                                  color: Color(0xFFE0E0E0),
                                  fontFamily: 'Inter',
                                  fontSize: isTablet ? 14.0 : 13.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: isTablet ? 3 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(height: 16),

                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Color(0xFF818181),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  Time,
                                  style: TextStyle(
                                    color: Color(0xFF818181),
                                    fontFamily: 'Inter',
                                    fontSize: isTablet ? 12.0 : 11.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                Spacer(),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3B1B9C),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    Genre,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontSize: isTablet ? 11.0 : 10.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error loading notes',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: fontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please try again later',
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: isTablet ? 14.0 : 12.0,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3B1B9C),
                strokeWidth: 3,
              ),
            ),
          );
        }
      },
    );
  }
}

class Diary extends StatefulWidget {
  const Diary({super.key});

  @override
  State<Diary> createState() => _Diary();
}

class _Diary extends State<Diary> {
  DateTime selectedDate = DateTime.now();
  DateTime calendarViewDate = DateTime.now();
  ScrollController _dateScrollController = ScrollController();

  String getUserGreeting() {
    final user = authService.value.currentUser;
    if (user != null) {
      final displayName =
          user.displayName ?? user.email?.split('@')[0] ?? 'User';
      final hour = DateTime.now().hour;
      String greeting;
      if (hour < 12) {
        greeting = 'Good Morning';
      } else if (hour < 18) {
        greeting = 'Good Afternoon';
      } else {
        greeting = 'Good Evening';
      }

      return '$greeting, $displayName';
    }
    return 'Good Afternoon, User';
  }

  List<DateTime> getDateRange() {
    final referenceDate = selectedDate;
    final lastDayOfMonth = DateTime(
      referenceDate.year,
      referenceDate.month + 1,
      0,
    );

    final totalDays = lastDayOfMonth.day;

    return List.generate(totalDays, (index) {
      return DateTime(referenceDate.year, referenceDate.month, index + 1);
    });
  }

  int getSelectedDateIndex() {
    return selectedDate.day - 1;
  }

  List<DateTime> getCalendarDays(DateTime referenceDate) {
    final firstDay = DateTime(referenceDate.year, referenceDate.month, 1);

    final firstWeekday = firstDay.weekday % 7;

    final startDate = firstDay.subtract(Duration(days: firstWeekday));

    final totalDays = 42;

    return List.generate(totalDays, (index) {
      return startDate.add(Duration(days: index));
    });
  }

  void _showCalendarModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final isTablet = MediaQuery.of(context).size.width > 600;
          final calendarDays = getCalendarDays(calendarViewDate);

          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Color(0xFF150A3A).withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Color(0xFFBDBDBD),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                calendarViewDate = DateTime(
                                  calendarViewDate.year,
                                  calendarViewDate.month - 1,
                                  1,
                                );
                              });
                            },
                            icon: Icon(Icons.chevron_left),
                            color: Colors.white,
                            iconSize: isTablet ? 32 : 28,
                          ),
                          Expanded(
                            child: Text(
                              DateFormat('MMMM yyyy').format(calendarViewDate),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet ? 24.0 : 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                calendarViewDate = DateTime(
                                  calendarViewDate.year,
                                  calendarViewDate.month + 1,
                                  1,
                                );
                              });
                            },
                            icon: Icon(Icons.chevron_right),
                            color: Colors.white,
                            iconSize: isTablet ? 32 : 28,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children:
                            ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                                .map(
                                  (day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          color: Color(0xFFBDBDBD),
                                          fontSize: isTablet ? 16.0 : 14.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),

                    SizedBox(height: 16),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                          itemCount: calendarDays.length,
                          itemBuilder: (context, index) {
                            final date = calendarDays[index];
                            final isCurrentMonth =
                                date.month == calendarViewDate.month;
                            final isSelected =
                                date.day == selectedDate.day &&
                                date.month == selectedDate.month &&
                                date.year == selectedDate.year;
                            final isToday =
                                date.day == DateTime.now().day &&
                                date.month == DateTime.now().month &&
                                date.year == DateTime.now().year;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = date;
                                });
                                Navigator.pop(context);
                                Future.delayed(Duration(milliseconds: 100), () {
                                  _scrollToSelectedDate();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFF3B1B9C)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: isToday
                                      ? Border.all(
                                          color: Color(0xFFF5DA3C),
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(
                                      color: !isCurrentMonth
                                          ? Color(0xFF666666)
                                          : isSelected
                                          ? Colors.white
                                          : isToday
                                          ? Color(0xFFF5DA3C)
                                          : Colors.white,
                                      fontSize: isTablet ? 18.0 : 16.0,
                                      fontWeight: isSelected || isToday
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    final selectedIndex = getSelectedDateIndex();
    final itemWidth = MediaQuery.of(context).size.width > 600 ? 72.0 : 62.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollPosition =
        selectedIndex * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    if (_dateScrollController.hasClients) {
      _dateScrollController.animateTo(
        scrollPosition.clamp(
          0.0,
          _dateScrollController.position.maxScrollExtent,
        ),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final days = getDateRange();
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? 32.0 : 24.0;
    final titleFontSize = isTablet ? 28.0 : 24.0;
    final subtitleFontSize = isTablet ? 18.0 : 16.0;

    return Scaffold(
      backgroundColor: Color(0xFF07011F),
      body: Stack(
        children: [
          Container(color: Color(0xFF07011F)),
          Opacity(
            opacity: 0.15,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Phone.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 20),

                      Text(
                        getUserGreeting(),
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 24),

                      Text(
                        selectedDate.day == DateTime.now().day &&
                                selectedDate.month == DateTime.now().month &&
                                selectedDate.year == DateTime.now().year
                            ? 'Today'
                            : DateFormat('MMMM dd, yyyy').format(selectedDate),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontFamily: 'Inter',
                          color: Color(0xFFE0E0E0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: isTablet ? 110 : 95,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF170B3F),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'images/Happy.png',
                                  height: isTablet ? 56 : 48,
                                  width: isTablet ? 56 : 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Your mood is good',
                                      style: TextStyle(
                                        fontSize: isTablet ? 20.0 : 18.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Keep it in your mood to be a good person',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: isTablet ? 14.0 : 12.0,
                                        color: Color(0xFFBDBDBD),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      Row(
                        children: [
                          Text(
                            'Your Diary',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isTablet ? 20.0 : 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                calendarViewDate = selectedDate;
                              });
                              _showCalendarModal();
                            },
                            icon: Icon(Icons.more_horiz),
                            color: Colors.white,
                            iconSize: isTablet ? 28 : 24,
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      SizedBox(
                        height: isTablet ? 120 : 100,
                        child: ListView.builder(
                          controller: _dateScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: days.length,
                          itemBuilder: (context, index) {
                            final date = days[index];
                            final isSelected =
                                date.day == selectedDate.day &&
                                date.month == selectedDate.month &&
                                date.year == selectedDate.year;
                            final isToday =
                                date.day == DateTime.now().day &&
                                date.month == DateTime.now().month &&
                                date.year == DateTime.now().year;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = date;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 12),
                                width: isTablet ? 60 : 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFF3B1B9C)
                                      : isToday
                                      ? Color(0xFF2A1A5C)
                                      : Color(0xFF150A3A),
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected
                                      ? Border.all(
                                          color: Color(0xFF5C2FC2),
                                          width: 2,
                                        )
                                      : isToday
                                      ? Border.all(
                                          color: Color(0xFFF5DA3C),
                                          width: 1,
                                        )
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Color(
                                              0xFF3B1B9C,
                                            ).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat.MMMM()
                                          .format(date)
                                          .toUpperCase()
                                          .substring(0, 3),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: isSelected
                                            ? Colors.white
                                            : isToday
                                            ? Color(0xFFF5DA3C)
                                            : Color(0xFFBDBDBD),
                                        fontSize: isTablet ? 11.0 : 10.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        fontSize: isTablet ? 28.0 : 24.0,
                                        color: isSelected
                                            ? Colors.white
                                            : isToday
                                            ? Color(0xFFF5DA3C)
                                            : Colors.white,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      DateFormat.E().format(date).toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: isTablet ? 11.0 : 10.0,
                                        color: isSelected
                                            ? Colors.white
                                            : isToday
                                            ? Color(0xFFF5DA3C)
                                            : Color(0xFFBDBDBD),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 12),

                      if (selectedDate.day != DateTime.now().day ||
                          selectedDate.month != DateTime.now().month ||
                          selectedDate.year != DateTime.now().year)
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedDate = DateTime.now();
                              });
                              _scrollToSelectedDate();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color(
                                0xFF3B1B9C,
                              ).withOpacity(0.2),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: Icon(
                              Icons.today,
                              color: Color(0xFFF5DA3C),
                              size: 16,
                            ),
                            label: Text(
                              'Today',
                              style: TextStyle(
                                color: Color(0xFFF5DA3C),
                                fontSize: isTablet ? 14.0 : 12.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 20),
                    ]),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverToBoxAdapter(
                    child: DiaryCard(selectedDate: selectedDate),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.only(bottom: 20),
                  sliver: SliverToBoxAdapter(child: SizedBox()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
