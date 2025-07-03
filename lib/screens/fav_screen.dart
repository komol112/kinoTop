import 'package:flutter/material.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "fav screen",
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade200
                    : Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
