import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/view/screens/fav_screen.dart';
import 'package:kino_top/view/screens/initial_screen.dart';
import 'package:kino_top/view/screens/myCard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = " ";
  String email = "";
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        setState(() {
          name = doc['firstName'] ?? "Name";
          email = doc['email'] ?? user.email ?? "";
        });
      }
    }
  }

  Future<void> _saveUserName(String newName) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': newName,
      });
    }
  }

  void _editNameDialog() {
    _nameController.text = name;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'edit_name'.tr(),
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'enter_new_name'.tr(),
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'cancel'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final newName = _nameController.text.trim();
                  if (newName.isEmpty) return;

                  setState(() {
                    name = newName;
                  });

                  await _saveUserName(newName);
                  Navigator.pop(context);
                },
                child: Text('save'.tr(), style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InitialScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Color(0xFF121011);
    final bgColor = isDark ? Color(0xFF121011) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          'profile'.tr(),
          style: TextStyle(
            fontSize: 24.sp,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _editNameDialog,
            child: Text("Edit", style: TextStyle(color: Colors.red)),
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              CircleAvatar(
                radius: 90.r,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                child: Icon(Icons.person, size: 90.r, color: textColor),
              ),
              SizedBox(height: 20.h),
              Text(
                name,
                style: TextStyle(
                  fontSize: 35.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 25.sp, color: Colors.grey.shade400),
              ),
              SizedBox(height: 30.h),
              Divider(color: textColor.withOpacity(0.2)),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.language, color: textColor),
                title: Text(
                  'language',
                  style: TextStyle(fontSize: 22.sp, color: textColor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 22.sp,
                  color: textColor,
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    builder: (_) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 20.w,
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Language',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              ListTile(
                                title: const Text('English'),
                                onTap: () {
                                  context.setLocale(const Locale('en'));
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('Русский'),
                                onTap: () {
                                  context.setLocale(const Locale('ru'));
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('Oʻzbekcha'),
                                onTap: () {
                                  context.setLocale(const Locale('uz'));
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.favorite_border_outlined, color: textColor),
                title: Text(
                  'your activity',
                  style: TextStyle(fontSize: 22.sp, color: textColor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 22.sp,
                  color: textColor,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavScreen()),
                  );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.video_collection_outlined,
                  color: textColor,
                ),
                title: Text(
                  'your movie',
                  style: TextStyle(fontSize: 22.sp, color: textColor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 22.sp,
                  color: textColor,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCardScreen()),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.logout_rounded, color: Colors.red),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 22.sp, color: Colors.red),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 22.sp,
                  color: Colors.red,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            "Log Out?",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 32.sp,
                            ),
                          ),

                          content: Text(
                            "are you sure wont to log out",
                            style: TextStyle(color: Colors.grey),
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "cencel",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _logout();
                              },
                              child: Text(
                                "yes",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
