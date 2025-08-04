import 'package:flutter/material.dart';
import 'package:personal_application/LoginPage/Login_Register_Page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:personal_application/LoginPage/forgotPassword.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Personal App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF3B1B9C)),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        forgotPassword.id: (context) => forgotPassword(),
        Navigation.id: (context) => Navigation(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
