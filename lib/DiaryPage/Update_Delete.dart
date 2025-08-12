import 'package:flutter/material.dart';
import 'package:personal_application/DiaryDatabase/DiaryCRUD.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';

class UpdateDelete extends StatefulWidget {
  static const String id = 'UpdateDelete';

  final String? docID;
  final String? title;
  final String? genre;
  final String? note;
  final String? time;

  const UpdateDelete({
    super.key,
    this.docID,
    this.genre,
    this.note,
    this.time,
    this.title,
  });

  @override
  State<UpdateDelete> createState() => _UpdateDelete();
}

class _UpdateDelete extends State<UpdateDelete> {
  TextEditingController time = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController genre = TextEditingController();
  TextEditingController textNote = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  String? docID;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.docID != null) {
      docID = widget.docID;
      title.text = widget.title ?? '';
      textNote.text = widget.note ?? '';
      genre.text = widget.genre ?? '';
      time.text = widget.time ?? '';
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final now = TimeOfDay.now();
        setState(() {
          time.text = now.format(context);
        });
      });
    }
  }

  Future<void> _updateNote() async {
    if (title.text.trim().isEmpty ||
        textNote.text.trim().isEmpty ||
        genre.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in the remaining text...'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (docID != null) {
        await firestoreService.updateNote(
          docID: docID!,
          newTitle: title.text.trim(),
          newGenre: genre.text.trim(),
          newNote: textNote.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated Successfully!!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await firestoreService.addNote(
          title: title.text.trim(),
          genre: genre.text.trim(),
          note: textNote.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added Successfully!!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pushReplacementNamed(context, Navigation.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteNote() async {
    if (docID == null) return;

    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1F192F),
          title: Text('Delete Note', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to delete this note? This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        isLoading = true;
      });

      try {
        await firestoreService.deleteNote(docID!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, Navigation.id);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting note: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                                  Text(
                                    docID != null
                                        ? 'Edit Note'
                                        : 'Add New Note',
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
                                            border: InputBorder.none,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _updateNote,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFF5DA3C),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              docID != null ? 'Update' : 'Add',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                    ),
                                  ),

                                  SizedBox(width: 8),

                                  if (docID != null)
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : _deleteNote,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF760000),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Delete',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
