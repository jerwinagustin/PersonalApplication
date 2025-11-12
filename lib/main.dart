import 'package:flutter/material.dart';
import 'package:personal_application/DiaryPage/DiaryNote.dart';
import 'package:personal_application/DiaryPage/Update_Delete.dart';
import 'package:personal_application/LoginPage/Login_Register_Page.dart';
import 'package:personal_application/LoginPage/LoadingScreen.dart';
import 'package:personal_application/Auth/AuthLayout.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:personal_application/LoginPage/forgotPassword.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';
import 'package:personal_application/Reminder/ReminderScreen.dart';
import 'package:personal_application/Reminder/reminderTime.dart';
import 'package:personal_application/LogoutPage/logout.dart';
import 'firebase_options.dart';
import 'package:personal_application/Notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogLife',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF3B1B9C)),
        useMaterial3: true,
      ),
      home: const Authlayout(),
      routes: {
        LoginPage.id: (context) => LoginPage(),
        LoadingScreen.id: (context) => LoadingScreen(),
        forgotPassword.id: (context) => forgotPassword(),
        Navigation.id: (context) => Navigation(),
        Diarynote.id: (context) => Diarynote(),
        UpdateDelete.id: (context) => UpdateDelete(),
        ReminderScreen.id: (context) => ReminderScreen(),
        Remindertime.id: (context) => Remindertime(),
        Logout.id: (context) => Logout(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
