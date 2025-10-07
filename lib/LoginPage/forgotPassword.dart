import "package:flutter/material.dart";
import "dart:ui";
import "../Auth/Authservice.dart";

class forgotPassword extends StatefulWidget {
  static const String id = "forgotPassword";
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await authService.value.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        _isSuccess = true;
        _message =
            "Password reset email sent successfully! Please check your inbox.";
      });
    } catch (e) {
      setState(() {
        _isSuccess = false;
        if (e.toString().contains("user-not-found")) {
          _message = "No account found with this email address.";
        } else if (e.toString().contains("invalid-email")) {
          _message = "Please enter a valid email address.";
        } else {
          _message = "Failed to send password reset email. Please try again.";
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  image: AssetImage("images/Phone.jpg"),
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
                    textAlign: TextAlign.center,
                    "OOPS, Looks like we have some\ninconvenience",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter",
                      fontSize: 18,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 103),
                            Text(
                              "Forgot Your Password?",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              textAlign: TextAlign.center,
                              "Please enter your email address to receive\na password reset link.",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                            SizedBox(height: 43),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your email address";
                                  }
                                  if (!RegExp(
                                    r"^[^@]+@[^@]+\.[^@]+",
                                  ).hasMatch(value)) {
                                    return "Please enter a valid email address";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter your email address",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF585858),
                                    fontFamily: "Inter",
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Color(0xFF585858),
                                    size: 24,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFD9D9D9),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            if (_message != null)
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _isSuccess
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _isSuccess
                                        ? Colors.green
                                        : Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _message!,
                                  style: TextStyle(
                                    color: _isSuccess
                                        ? Colors.green
                                        : Colors.red,
                                    fontFamily: "Inter",
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (_message != null) SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : _sendPasswordResetEmail,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isLoading
                                      ? Colors.grey
                                      : Color(0xFF3B1B9C),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Sending...",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "Send Reset Email",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Back to Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
}
