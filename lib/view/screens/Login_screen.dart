import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kino_top/view/screens/navigation_screen.dart';
import 'package:kino_top/view/screens/sign_up_screen.dart';
import 'package:kino_top/repasitories/services/login_and_signIn_service.dart';

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
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF121011)
              : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(19.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF121011)
                          : Colors.white,
                ),
              ),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelStyle: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Color(0xFF121011)
                            : Colors.grey,
                  ),
                  labelText: "E-mail",

                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF121011)
                          : Colors.grey,
                ),
              ),

              TextField(
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF121011)
                          : Colors.grey,
                ),

                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelStyle: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Color(0xFF121011)
                            : Colors.grey,
                  ),
                  labelText: 'password',
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey,
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'forgot_password'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Color(0xFF121011)
                                : Colors.grey.shade300,
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

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NavigationScreen(),
                      ),
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
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF121011)
                          : Colors.white,
                ),
                child:
                    isLoading
                        ? CircularProgressIndicator(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF121011)
                                  : Colors.white,
                        )
                        : const Text("Sign in"),
              ),

              errorText.isNotEmpty
                  ? Text(errorText, style: TextStyle(color: Colors.red))
                  : Text(""),

              Row(
                spacing: 10,
                children: [
                  Expanded(child: Divider()),
                  Text(
                    'or'.tr(),
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey.shade300,
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFF1E1E1E)
                              : Colors.white,
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

                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFF1E1E1E)
                              : Colors.white,
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

                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFF1E1E1E)
                              : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.tiktok),
                  ),
                ],
              ),

              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'have_account'.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey,
                    ),
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
