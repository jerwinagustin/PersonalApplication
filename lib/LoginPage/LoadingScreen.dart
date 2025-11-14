import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import '../NavigationBar/Navigation.dart';
import '../Responsiveness/Responsive.dart';
import '../LoginPage/Login_Register_Page.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loadingScreen';
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _rotationController.repeat();
    _fadeController.repeat(reverse: true);

    _navigateToMainApp();
  }

  Future<void> _navigateToMainApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, Navigation.id);
    } else {
      Navigator.pushReplacementNamed(context, LoginPage.id);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Color(0xFF3B1B9C)),

          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Phone.jpg'),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    debugPrint('Background image failed to load: $exception');
                  },
                ),
              ),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveSpacing(context, 20.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: ResponsiveHelper.isMobile(context)
                      ? ResponsiveHelper.getScreenWidth(context) * 0.75
                      : ResponsiveHelper.isTablet(context)
                      ? 320
                      : 350,
                  height: ResponsiveHelper.isMobile(context)
                      ? ResponsiveHelper.getScreenHeight(context) * 0.25
                      : ResponsiveHelper.isTablet(context)
                      ? 220
                      : 240,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getResponsiveSpacing(context, 20.0),
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ResponsiveHelper.getResponsiveIconSize(
                          context,
                          60.0,
                        ),
                        height: ResponsiveHelper.getResponsiveIconSize(
                          context,
                          60.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getResponsiveSpacing(
                              context,
                              15.0,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: ResponsiveHelper.getResponsiveIconSize(
                            context,
                            30.0,
                          ),
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          20.0,
                        ),
                      ),

                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value * 2.0 * 3.14159,
                            child: Container(
                              width: ResponsiveHelper.getResponsiveIconSize(
                                context,
                                40.0,
                              ),
                              height: ResponsiveHelper.getResponsiveIconSize(
                                context,
                                40.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getResponsiveSpacing(
                                    context,
                                    20.0,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    right: BorderSide.none,
                                    bottom: BorderSide.none,
                                    left: BorderSide.none,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.getResponsiveSpacing(
                                      context,
                                      20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          20.0,
                        ),
                      ),

                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Text(
                              'Welcome Back!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      18.0,
                                    ),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          8.0,
                        ),
                      ),

                      Text(
                        'Loading your personal space...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            12.0,
                          ),
                          fontFamily: 'Inter',
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
    );
  }
}
