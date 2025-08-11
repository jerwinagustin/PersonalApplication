import 'package:flutter/material.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';

class Diarynote extends StatefulWidget {
  static const String id = 'Diarynote';
  const Diarynote({super.key});

  @override
  State<Diarynote> createState() => _Diarynote();
}

class _Diarynote extends State<Diarynote> {
  TextEditingController time = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController genre = TextEditingController();
  TextEditingController textNote = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = TimeOfDay.now();

      setState(() {
        time.text = now.format(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: const Color(0xFF170B3F)),
            Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/Phone.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9900FF),
                            Color(0xFF413243),
                            Color(0xFFFF00AA),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 493,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF03000F),
                                Color(0xFF050017),
                                Color(0xFF170B3F),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 31,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.pushNamed(
                                            context,
                                            Navigation.id,
                                          );
                                        });
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      'Add New Note',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                SizedBox(
                                  height: 35,

                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF9900FF),
                                          Color(0xFF666666),
                                        ],
                                      ),
                                    ),
                                    padding: EdgeInsets.all(1.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1F192F),
                                      ),
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: title,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 9,
                                            vertical: 6,
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Enter Your Title...',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Color(0xFFE0E0E0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),

                                Row(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      width: 140,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF9900FF),
                                              Color(0xFF666666),
                                            ],
                                          ),
                                        ),

                                        padding: EdgeInsets.all(1.5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF1F192F),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextField(
                                            controller: time,
                                            readOnly: true,
                                            enabled: false,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              color: Color(0xFFC3C3C3),
                                            ),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.timer,
                                                size: 12,
                                                color: Color(0xFFC3C3C3),
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 9,
                                                    vertical: 6,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 4),

                                    SizedBox(
                                      height: 35,
                                      width: 160,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF9900FF),
                                              Color(0xFF666666),
                                            ],
                                          ),
                                        ),
                                        padding: EdgeInsets.all(1.5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF1F192F),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextField(
                                            controller: genre,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 9,
                                                    vertical: 6,
                                                  ),
                                              border: InputBorder.none,
                                              hintText: 'Enter Your Genre...',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                color: Color(0xFFE0E0E0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15),

                                SizedBox(
                                  height: 237,

                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF9900FF),
                                          Color(0xFF666666),
                                        ],
                                      ),
                                    ),
                                    padding: EdgeInsets.all(1.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1F192F),
                                      ),

                                      child: TextField(
                                        controller: textNote,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 9,
                                            vertical: 6,
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Enter Your Note...',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Color(0xFFE0E0E0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF3B1B9C),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Save Note',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
