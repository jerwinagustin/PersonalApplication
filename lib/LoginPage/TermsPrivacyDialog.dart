import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_application/Responsiveness/Responsive.dart';

class TermsPrivacyDialog extends StatefulWidget {
  final String type; // 'terms' or 'privacy'
  
  const TermsPrivacyDialog({
    super.key,
    required this.type,
  });

  @override
  State<TermsPrivacyDialog> createState() => _TermsPrivacyDialogState();
}

class _TermsPrivacyDialogState extends State<TermsPrivacyDialog>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _startAnimations();
  }
  
  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String get _title => widget.type == 'terms' ? 'Terms of Service' : 'Privacy Policy';
  
  String get _content => widget.type == 'terms' ? _termsContent : _privacyContent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.7 * _fadeAnimation.value),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20.0),
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        maxWidth: ResponsiveHelper.isMobile(context) ? double.infinity : 600,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1a1a2e),
                            Color(0xFF16213e),
                            Color(0xFF0f3460),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF3B1B9C).withOpacity(0.8),
                                  const Color(0xFF6A4C93).withOpacity(0.6),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    widget.type == 'terms' ? Icons.gavel_rounded : Icons.privacy_tip_rounded,
                                    color: Colors.white,
                                    size: ResponsiveHelper.getResponsiveFontSize(context, 24.0),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    _title,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Content
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(24.0),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Text(
                                  _content,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16.0),
                                    height: 1.6,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Footer
                          Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white.withOpacity(0.7),
                                  size: ResponsiveHelper.getResponsiveFontSize(context, 16.0),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Last updated: ${DateTime.now().year}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14.0),
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B1B9C),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 12.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Got it',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16.0),
                                      fontWeight: FontWeight.w600,
                                    ),
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
              },
            ),
          ),
        );
      },
    );
  }

  static const String _termsContent = '''
Welcome to LogLife! These Terms of Service ("Terms") govern your use of our mobile application and services.

1. ACCEPTANCE OF TERMS
By accessing and using LogLife, you accept and agree to be bound by the terms and provision of this agreement.

2. USE LICENSE
Permission is granted to temporarily download one copy of LogLife per device for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:
• Modify or copy the materials
• Use the materials for any commercial purpose or for any public display
• Attempt to reverse engineer any software contained in LogLife
• Remove any copyright or other proprietary notations from the materials

3. USER ACCOUNTS
When you create an account with us, you must provide information that is accurate, complete, and current at all times. You are responsible for safeguarding the password and for all activities that occur under your account.

4. PRIVACY AND DATA PROTECTION
Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our service.

5. USER CONTENT
Our service allows you to post, link, store, share and otherwise make available certain information, text, graphics, or other material ("Content"). You are responsible for the Content that you post to the service.

6. PROHIBITED USES
You may not use our service:
• For any unlawful purpose or to solicit others to perform unlawful acts
• To violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances
• To infringe upon or violate our intellectual property rights or the intellectual property rights of others
• To harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate
• To submit false or misleading information

7. SERVICE AVAILABILITY
We reserve the right to withdraw or amend our service, and any service or material we provide via the application, in our sole discretion without notice. We do not warrant that our service will be available at all times.

8. LIMITATION OF LIABILITY
In no event shall LogLife, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, punitive, consequential, or special damages.

9. GOVERNING LAW
These Terms shall be interpreted and governed by the laws of the jurisdiction in which our company is established, without regard to its conflict of law provisions.

10. CHANGES TO TERMS
We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days notice prior to any new terms taking effect.

11. CONTACT INFORMATION
If you have any questions about these Terms of Service, please contact us through the app or via our official support channels.

By using LogLife, you acknowledge that you have read these Terms of Service and agree to be bound by them.
''';

  static const String _privacyContent = '''
LogLife Privacy Policy

Last updated: ${2024}

This Privacy Policy describes how LogLife ("we", "our", or "us") collects, uses, and shares your personal information when you use our mobile application.

1. INFORMATION WE COLLECT

Personal Information:
• Email address (for account creation and authentication)
• Display name or username
• Profile information you choose to provide

Usage Data:
• App usage statistics and analytics
• Device information (device type, operating system)
• Log data (IP address, browser type, pages visited)

Content Data:
• Diary entries and personal notes you create
• Reminders and tasks you set
• Weather location data (if you enable location services)

2. HOW WE USE YOUR INFORMATION

We use the collected information for:
• Providing and maintaining our service
• Authenticating your identity and managing your account
• Personalizing your experience within the app
• Sending you technical notices and support messages
• Improving our app's functionality and user experience
• Analyzing usage patterns to enhance our services

3. INFORMATION SHARING AND DISCLOSURE

We do not sell, trade, or otherwise transfer your personal information to third parties except:
• With your explicit consent
• To comply with legal obligations
• To protect our rights and safety
• With trusted service providers who assist in operating our app (under strict confidentiality agreements)

Third-Party Services:
• Firebase (Google) - for authentication and data storage
• Weather APIs - for weather information (location data may be shared)

4. DATA SECURITY

We implement appropriate security measures to protect your personal information:
• Encryption of data in transit and at rest
• Secure authentication protocols
• Regular security assessments
• Limited access to personal data by our team

5. DATA RETENTION

We retain your personal information only as long as necessary:
• Account information: Until you delete your account
• Usage data: Up to 2 years for analytics purposes
• Content data: Until you delete it or close your account

6. YOUR RIGHTS AND CHOICES

You have the right to:
• Access your personal information
• Correct inaccurate information
• Delete your account and associated data
• Export your data
• Opt-out of certain data collection practices

7. CHILDREN'S PRIVACY

Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.

8. INTERNATIONAL DATA TRANSFERS

Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place for such transfers.

9. COOKIES AND TRACKING TECHNOLOGIES

We use cookies and similar technologies to:
• Remember your preferences
• Analyze app usage
• Improve functionality
• Provide personalized content

10. CHANGES TO THIS PRIVACY POLICY

We may update this Privacy Policy from time to time. We will notify you of any changes by:
• Posting the new Privacy Policy in the app
• Sending you an email notification
• Displaying a prominent notice in the app

11. CALIFORNIA PRIVACY RIGHTS

If you are a California resident, you have additional rights under the California Consumer Privacy Act (CCPA):
• Right to know what personal information is collected
• Right to delete personal information
• Right to opt-out of the sale of personal information
• Right to non-discrimination for exercising your rights

12. CONTACT US

If you have any questions about this Privacy Policy or our data practices, please contact us:
• Through the app's support feature
• Via our official website
• By email at our designated privacy contact

Your privacy is important to us, and we are committed to protecting your personal information while providing you with the best possible experience using LogLife.
''';
}

// Helper function to show the dialog
void showTermsPrivacyDialog(BuildContext context, String type) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return TermsPrivacyDialog(type: type);
    },
  );
}