import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/view/screens/initial_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "      ";
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
            title: Text("Edit Name", style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter new name",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
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
                child: Text("Save", style: TextStyle(color: Colors.red)),
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 25.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white70,
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.person, color: Colors.white, size: 120.r),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 25.sp, color: Colors.white),
                      ),
                      SizedBox(width: 10.w),
                      IconButton(
                        onPressed: _editNameDialog,
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    email,
                    style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}