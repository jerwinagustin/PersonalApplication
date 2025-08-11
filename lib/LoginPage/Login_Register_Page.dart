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
    return Container(
      width: 350,
      height: 80,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: isLogin ? Alignment.centerLeft : Alignment.centerRight,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 160,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
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
                        color: !isLogin ? Colors.black : Color(0xFF747474),
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
  bool _ObscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _ObscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        hintStyle: TextStyle(
          fontFamily: "Inter",
          fontSize: 10,
          color: Color(0xFF818181),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(_ObscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _ObscureText = !_ObscureText;
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
  State<RememberMe> createState() => _RememberMe();
}

class _RememberMe extends State<RememberMe> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
          side: BorderSide(color: Colors.white, width: 2),
        ),
        Text('Remember Me', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black,
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
  State<RegisterPasswordField> createState() => _RegisterPasswordField();
}

class _RegisterPasswordField extends State<RegisterPasswordField> {
  bool _ObscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _ObscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(_ObscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _ObscureText = !_ObscureText;
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
  State<ConfirmPassword> createState() => _ConfirmPassword();
}

class _ConfirmPassword extends State<ConfirmPassword> {
  bool _ObscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _ObscureText,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(_ObscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _ObscureText = !_ObscureText;
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
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool isLogin = true;
  String? passwordMessage;
  bool? passwordMatch;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    confirmpasswordController.addListener(checkPasswordMatch);
  }

  void Register() async {
    try {
      await authService.value.createAccount(
        email: emailController.text,
        password: confirmpasswordController.text,
        username: usernameController.text,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful!'),
            content: Text(
              "Welcome, ${usernameController.text}! you can now log in.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ToggleAuth(true);
                },
                child: Text('OK'),
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

  void Login() async {
    try {
      await authService.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pushNamed(context, Navigation.id);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'There is an error';
      });
    }
  }

  void checkPasswordMatch() {
    String password = passwordController.text.trim();
    String confirm = confirmpasswordController.text.trim();

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
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  void ToggleAuth(bool showLogin) {
    setState(() => isLogin = showLogin);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                ),
              ),
            ),
          ),

          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: Text(
                    isLogin ? 'WELCOME BACK!' : 'JOIN IN!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Spacer(),

              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(37),
                  topRight: Radius.circular(37),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 700,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(37),
                        topRight: Radius.circular(37),
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 0),
                          AuthSwitcher(isLogin: isLogin, onToggle: ToggleAuth),

                          SizedBox(height: 12),
                          Text(
                            isLogin
                                ? 'Go ahead and Sign in your account'
                                : 'Go ahead and register your account',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            isLogin
                                ? 'Sign in to enjoy the best experience'
                                : 'Register to enjoy the best experience',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFBDBDBD),
                              fontSize: 15,
                            ),
                          ),

                          SizedBox(height: 30),

                          SingleChildScrollView(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: isLogin
                                  ? Column(
                                      key: ValueKey('login'),
                                      children: [
                                        TextField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            labelText: 'Email Address',
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 20,
                                                  horizontal: 14,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20),

                                        PasswordField(
                                          controller: passwordController,
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RememberMe(),
                                            ForgotPassword(),
                                          ],
                                        ),
                                        Text(
                                          errorMessage,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),

                                        ElevatedButton(
                                          onPressed: () {
                                            Login();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF3B1B9C),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 145,
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'CONTINUE',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),

                                        Row(
                                          children: [
                                            SizedBox(height: 60),
                                            SizedBox(
                                              width: 160,
                                              child: Divider(
                                                color: Color(0xFFE6E6E6),
                                                thickness: 1,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Text(
                                                'Or',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Color(0xFFBDBDBD),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 160,
                                              child: Divider(
                                                color: Color(0xFFE6E6E6),
                                                thickness: 1,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          width: 360,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              minimumSize: Size(
                                                double.infinity,
                                                50,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Google.png',
                                                  height: 24,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  'Continue with Google',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 30),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'By clicking continue, you agree to our',
                                                  ),
                                                  TextSpan(
                                                    text: 'Terms of Service',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                                children: [
                                                  TextSpan(text: 'and '),
                                                  TextSpan(
                                                    text: 'Privacy Policy',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      key: ValueKey('register'),
                                      children: [
                                        TextField(
                                          controller: usernameController,
                                          decoration: InputDecoration(
                                            labelText: 'Username',
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 14,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20),

                                        TextField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            labelText: 'Email Address',
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 14,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20),

                                        RegisterPasswordField(
                                          controller: passwordController,
                                        ),

                                        SizedBox(height: 20),

                                        ConfirmPassword(
                                          controller: confirmpasswordController,
                                        ),

                                        if (passwordMessage != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: Text(
                                              passwordMessage!,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: passwordMatch == true
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ),

                                        Text(
                                          errorMessage,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        SizedBox(height: 2),

                                        ElevatedButton(
                                          onPressed: () {
                                            Register();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF3B1B9C),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 145,
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadiusGeometry.circular(
                                                    12,
                                                  ),
                                            ),
                                          ),
                                          child: Text(
                                            'REGISTER',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 62),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'By clicking continue, you agree to our',
                                                    ),
                                                    TextSpan(
                                                      text: 'Terms of Service',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                  children: [
                                                    TextSpan(text: 'and '),
                                                    TextSpan(
                                                      text: 'Privacy Policy',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
        ],
      ),
    );
  }
}
