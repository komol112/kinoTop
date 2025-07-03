import 'package:flutter/material.dart';

class HitoryScreen extends StatelessWidget {
  const HitoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "history Screen",
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade200
                    : Colors.grey.shade900
          ),
        ),
      ),
    );
  }
}
