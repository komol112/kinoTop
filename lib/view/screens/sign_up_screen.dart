import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kino_top/view/screens/navigation_screen.dart';
import 'package:kino_top/repasitories/services/login_and_signIn_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firsNamecontroller = TextEditingController();
  final lastNamecontroller = TextEditingController();
  var errorText = "";
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    firsNamecontroller.dispose();
    lastNamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF121011)
              : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  "Sign Up",
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
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Color(0xFF121011)
                            : Colors.grey,
                  ),

                  controller: firsNamecontroller,

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelStyle: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey,
                    ),
                    labelText: 'first_name'.tr(),
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

                TextField(
                  controller: lastNamecontroller,
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Color(0xFF121011)
                            : Colors.grey,
                  ),

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelStyle: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF121011)
                              : Colors.grey,
                    ),
                    labelText: 'last_name'.tr(),
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

                TextField(
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Color(0xFF121011)
                            : Colors.grey,
                  ),

                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline),
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
                    labelText: 'password'.tr(),
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

                ElevatedButton(
                  onPressed: () async {
                    setState(() => isLoading = true);

                    try {
                      await FirebaseService.registerUser(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        firstName: firsNamecontroller.text,
                        lastName: lastNamecontroller.text,
                      );

                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationScreen(),
                        ),
                      );

                      emailController.clear();
                      passwordController.clear();
                      firsNamecontroller.clear();
                      lastNamecontroller.clear();
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Color(0xFF121011)
                            : Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child:
                      isLoading
                          ? CircularProgressIndicator(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Color(0xFF121011)
                                    : Colors.white,
                          )
                          : const Text("Sign In"),
                ),

                errorText.isEmpty
                    ? RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'create_account_note'.tr(),
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF121011)
                                  : Colors.grey.shade700,
                          fontWeight: FontWeight.w300,
                          fontSize: 17.5.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'terms_of_use'.tr(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color(0xFF121011)
                                      : Colors.grey,
                            ),
                          ),
                          TextSpan(text: 'and'.tr()),
                          TextSpan(
                            text: 'privacy_policy'.tr(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color(0xFF121011)
                                      : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    : Text(errorText, style: TextStyle(color: Colors.red)),

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
                                : Colors.grey,
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
                          borderRadius: BorderRadius.circular(10.r),
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
                          borderRadius: BorderRadius.circular(10.r),
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
                          borderRadius: BorderRadius.circular(10.r),
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
                      'have_account'.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Color(0xFF121011)
                                : Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Color(0xFf156651)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
