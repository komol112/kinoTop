import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kino_top/screens/home_secreen.dart';
import 'package:kino_top/screens/sign_up_screen.dart';
import 'package:kino_top/services/login_and_signIn_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String errorText = "";

  FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFf121011),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelStyle: TextStyle(color: Colors.grey),
                  labelText: "E-mail",

                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: TextStyle(color: Colors.grey),
              ),

              TextField(
                                style: TextStyle(color: Colors.grey),

                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelStyle: TextStyle(color: Colors.grey),
                  labelText: "Password",
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),

              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                    errorText = "";
                  }); // loaderni yoq

                  try {
                    await FirebaseService.loginUser(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    await Future.delayed(const Duration(seconds: 2));

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeSecreen()),
                    );

                    emailController.clear();
                    passwordController.clear();
                  } catch (e) {
                    setState(() {
                      errorText = e.toString();
                    });

                    log("Xatolik: $e");
                  } finally {
                    setState(() => isLoading = false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB2F3D),
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white,
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign in"),
              ),

              errorText.isNotEmpty
                  ? Text(errorText, style: TextStyle(color: Colors.red))
                  : Text(""),

              Row(
                spacing: 10,
                children: [
                  Expanded(child: Divider()),
                  Text("OR", style: TextStyle(color: Colors.grey.shade300)),
                  Expanded(child: Divider()),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      backgroundColor: Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset("assets/svgs/google.svg"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),

                      backgroundColor: Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset("assets/svgs/facebook.svg"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),

                      backgroundColor: Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.tiktok),
                  ),
                ],
              ),

              SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Color(0xFf156651)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
