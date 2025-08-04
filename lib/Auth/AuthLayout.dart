import 'package:flutter/material.dart';
import 'package:personal_application/Auth/Authservice.dart';
import 'package:personal_application/LoginPage/AppLoadingPage.dart';
import 'package:personal_application/LoginPage/Login_Register_Page.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';

class Authlayout extends StatelessWidget {
  const Authlayout({super.key, this.pageIfNotFound});
  final Widget? pageIfNotFound;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = AppLoadingPage();
            } else if (snapshot.hasData) {
              widget = const Navigation();
            } else {
              widget = pageIfNotFound ?? const LoginPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
