import 'package:flutter/material.dart';

class HomeSecreen extends StatefulWidget {
  const HomeSecreen({super.key});

  @override
  State<HomeSecreen> createState() => _HomeSecreenState();
}

class _HomeSecreenState extends State<HomeSecreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("homeScreen")));
  }
}
