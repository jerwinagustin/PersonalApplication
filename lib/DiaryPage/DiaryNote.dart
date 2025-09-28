import 'package:flutter/material.dart';
import 'package:personal_application/DiaryDatabase/DiaryCRUD.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';

class Diarynote extends StatefulWidget {
  static const String id = 'Diarynote';
  final DateTime? selectedDate;

  const Diarynote({super.key, this.selectedDate});

  @override
  State<Diarynote> createState() => _Diarynote();
}

class _Diarynote extends State<Diarynote> {
  TextEditingController time = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController genre = TextEditingController();
  TextEditingController textNote = TextEditingController();

  bool isLoading = false;
  final FirestoreService _firestoreService = FirestoreService();
  late DateTime noteDate;

  @override
  void initState() {
    super.initState();

    noteDate = widget.selectedDate ?? DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = TimeOfDay.now();

      setState(() {
        time.text = now.format(context);
      });
    });
  }

  Future<void> _saveNote() async {
    if (title.text.trim().isEmpty) {
      _showErrorDialog('Please enter a title');
      return;
    }

    if (textNote.text.trim().isEmpty) {
      _showErrorDialog('Please enter your note');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _firestoreService.addNote(
        title: title.text.trim(),
        genre: genre.text.trim().isEmpty ? 'General' : genre.text.trim(),
        note: textNote.text.trim(),
        selectedDate: noteDate,
      );
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Failed to save note: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF170B3F),
          title: Text(
            'Error',
            style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFF3B1B9C), fontFamily: 'Inter'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF170B3F),
          title: Text(
            'Success',
            style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
          ),
          content: Text(
            'Note saved successfully!',
            style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, Navigation.id);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFF3B1B9C), fontFamily: 'Inter'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
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

              Padding(
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
                                        Navigator.pushReplacementNamed(
                                          context,
                                          Navigation.id,
                                        );
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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

                                    Expanded(
                                      child: SizedBox(
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
                                        maxLines: null,
                                        expands: true,
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
                                    onPressed: isLoading ? null : _saveNote,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF3B1B9C),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isLoading
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
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
              if (isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF3B1B9C)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    time.dispose();
    title.dispose();
    genre.dispose();
    textNote.dispose();
    super.dispose();
  }
}
