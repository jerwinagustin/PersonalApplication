import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_application/Auth/Authservice.dart';
import 'package:personal_application/LoginPage/Login_Register_Page.dart';
import 'package:personal_application/Responsiveness/Responsive.dart';

class Logout extends StatefulWidget {
  static const String id = 'logout';
  const Logout({super.key});

  @override
  State<Logout> createState() => _Logout();
}

class _Logout extends State<Logout> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations
    _startAnimations();
  }
  
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Add haptic feedback
      HapticFeedback.mediumImpact();
      
      // Show loading animation
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Use the enhanced secure sign out method
      bool success = await authService.value.secureSignOut();
      
      if (success) {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        // Handle sign out failure
        setState(() {
          _isLoggingOut = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to sign out. Please try again.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoggingOut = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred during sign out.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _showLogoutDialog() {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: const Color(0xFF4E2FB8),
                  size: ResponsiveHelper.getResponsiveFontSize(context, 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to logout from your account?',
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleLogout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E2FB8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = ResponsiveHelper.getScreenHeight(context);
    final screenWidth = ResponsiveHelper.getScreenWidth(context);
    final padding = ResponsiveHelper.getResponsivePadding(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: padding,
              child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.isMobile(context) ? 20 : 30,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4E2FB8),
                          Color(0xFF6A4C93),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4E2FB8).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: ResponsiveHelper.getResponsiveFontSize(context, 40),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Account Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Manage your account preferences',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // User Info Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: const Color(0xFF4E2FB8),
                              size: ResponsiveHelper.getResponsiveFontSize(context, 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Current User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          authService.value.currentUser?.displayName ?? 'User',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authService.value.currentUser?.email ?? 'No email',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Logout Button Section
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: double.infinity,
                      height: ResponsiveHelper.isMobile(context) ? 60 : 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoggingOut ? null : _showLogoutDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoggingOut
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Logging out...',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    size: ResponsiveHelper.getResponsiveFontSize(context, 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Footer
                  Text(
                    'Thank you for using our app!',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveHelper.isMobile(context) ? 100 : 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
