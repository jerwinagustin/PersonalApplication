import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_application/Auth/Authservice.dart';
import 'dart:ui';
import 'package:personal_application/LoginPage/forgotPassword.dart';
import 'package:personal_application/NavigationBar/Navigation.dart';

class AuthSwitcher extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onToggle;

  const AuthSwitcher({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final switcherWidth = (screenWidth * 0.85).clamp(300.0, 400.0);
    final switcherHeight = screenWidth * 0.18;

    return Container(
      width: switcherWidth,
      height: switcherHeight.clamp(70.0, 90.0),
      padding: EdgeInsets.all(screenWidth * 0.01),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(switcherHeight / 2),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: isLogin ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              width: switcherWidth / 2 - (screenWidth * 0.02),
              height: switcherHeight.clamp(70.0, 90.0) - (screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(switcherHeight / 2),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                        color: isLogin ? Colors.black : Color(0xFF747474),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(false),
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                        color: isLogin ? Color(0xFF747474) : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontSize: (screenWidth * 0.04).clamp(14.0, 16.0)),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.05,
          horizontal: screenWidth * 0.04,
        ),
        hintStyle: TextStyle(
          fontFamily: "Inter",
          fontSize: (screenWidth * 0.025).clamp(10.0, 14.0),
          color: const Color(0xFF818181),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: (screenWidth * 0.003).clamp(0.8, 1.2),
          child: Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },
            side: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        Text(
          'Remember Me',
          style: TextStyle(
            color: Colors.white,
            fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
          ),
        ),
      ],
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: (screenWidth * 0.03).clamp(11.0, 14.0),
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, forgotPassword.id);
      },
    );
  }
}

class RegisterPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const RegisterPasswordField({super.key, required this.controller});

  @override
  State<RegisterPasswordField> createState() => _RegisterPasswordFieldState();
}

class _RegisterPasswordFieldState extends State<RegisterPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontSize: (screenWidth * 0.04).clamp(14.0, 16.0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.035,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class ConfirmPassword extends StatefulWidget {
  final TextEditingController controller;

  const ConfirmPassword({super.key, required this.controller});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        labelStyle: TextStyle(fontSize: (screenWidth * 0.04).clamp(14.0, 16.0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.035,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLogin = true;
  String? passwordMessage;
  bool? passwordMatch;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    confirmPasswordController.addListener(checkPasswordMatch);
  }

  void register() async {
    try {
      await authService.value.createAccount(
        email: emailController.text,
        password: confirmPasswordController.text,
        username: usernameController.text,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Successful!'),
            content: Text(
              "Welcome, ${usernameController.text}! you can now log in.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  toggleAuth(true);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'There is an error';
      });
    }
  }

  void login() async {
    try {
      await authService.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.pushNamed(context, Navigation.id);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'There is an error';
      });
    }
  }

  void checkPasswordMatch() {
    String password = passwordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    setState(() {
      if (confirm.isEmpty) {
        passwordMatch = null;
        passwordMessage = null;
      } else if (password != confirm) {
        passwordMatch = false;
        passwordMessage = 'Password do not match!';
      } else {
        passwordMatch = true;
        passwordMessage = 'Password match';
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void toggleAuth(bool showLogin) {
    setState(() => isLogin = showLogin);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFF3B1B9C)),
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Phone.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: isSmallScreen
                        ? screenHeight * 0.08
                        : screenHeight * 0.12,
                  ),
                  child: Text(
                    isLogin ? 'WELCOME BACK!' : 'JOIN IN!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: (screenWidth * 0.06).clamp(20.0, 28.0),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: isSmallScreen
                    ? screenHeight * 0.72
                    : screenHeight * 0.78,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.1),
                    topRight: Radius.circular(screenWidth * 0.1),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(screenWidth * 0.1),
                          topRight: Radius.circular(screenWidth * 0.1),
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                          vertical: screenWidth * 0.06,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AuthSwitcher(
                              isLogin: isLogin,
                              onToggle: toggleAuth,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              isLogin
                                  ? 'Go ahead and Sign in your account'
                                  : 'Go ahead and register your account',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: (screenWidth * 0.052).clamp(
                                  18.0,
                                  24.0,
                                ),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              isLogin
                                  ? 'Sign in to enjoy the best experience'
                                  : 'Register to enjoy the best experience',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFBDBDBD),
                                fontSize: (screenWidth * 0.038).clamp(
                                  13.0,
                                  17.0,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isLogin
                                  ? _buildLoginForm()
                                  : _buildRegisterForm(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Column(
      key: const ValueKey('login'),
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            labelStyle: TextStyle(
              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.05,
              horizontal: screenWidth * 0.04,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        PasswordField(controller: passwordController),
        SizedBox(height: screenHeight * 0.012),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [RememberMe(), ForgotPassword()],
        ),
        SizedBox(height: screenHeight * 0.012),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.012),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B1B9C),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
            ),
            child: Text(
              'CONTINUE',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: (screenWidth * 0.035).clamp(13.0, 16.0),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        Row(
          children: [
            const Expanded(
              child: Divider(color: Color(0xFFE6E6E6), thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Text(
                'Or',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: (screenWidth * 0.035).clamp(14.0, 16.0),
                  color: const Color(0xFFBDBDBD),
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: Color(0xFFE6E6E6), thickness: 1),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.025),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/Google.png', height: screenWidth * 0.06),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: (screenWidth * 0.035).clamp(14.0, 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: (screenWidth * 0.03).clamp(12.0, 14.0),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            children: const [
              TextSpan(text: 'By clicking continue, you agree to our '),
              TextSpan(
                text: 'Terms of Service',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Column(
      key: const ValueKey('register'),
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(
              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenWidth * 0.035,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            labelStyle: TextStyle(
              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenWidth * 0.035,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        RegisterPasswordField(controller: passwordController),
        SizedBox(height: screenHeight * 0.025),
        ConfirmPassword(controller: confirmPasswordController),
        if (passwordMessage != null)
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: Text(
              passwordMessage!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: (screenWidth * 0.03).clamp(12.0, 14.0),
                fontWeight: FontWeight.w500,
                color: passwordMatch == true ? Colors.green : Colors.red,
              ),
            ),
          ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
              ),
            ),
          ),
        SizedBox(height: screenHeight * 0.012),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: register,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B1B9C),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
            ),
            child: Text(
              'REGISTER',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: (screenWidth * 0.035).clamp(14.0, 16.0),
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: (screenWidth * 0.03).clamp(12.0, 14.0),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            children: const [
              TextSpan(text: 'By clicking continue, you agree to our '),
              TextSpan(
                text: 'Terms of Service',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
