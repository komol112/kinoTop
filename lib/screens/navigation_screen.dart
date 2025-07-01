import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kino_top/screens/fav_screen.dart';
import 'package:kino_top/screens/home_secreen.dart';
import 'package:kino_top/screens/details_screen.dart';
import 'package:kino_top/screens/history_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectectedIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    HitoryScreen(),
    DetailsScreen(),
    FavScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            onTap: (value) {
              log(value.toString());
              setState(() {
                selectectedIndex = value;
              });
            },
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.red,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            currentIndex: selectectedIndex,
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(
                  Icons.home,
                  color: selectectedIndex == 0 ? Colors.grey : Colors.red,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.phone,
                  color: selectectedIndex == 1 ? Colors.grey : Colors.red,
                ),

                label: "phone",
              ),
              BottomNavigationBarItem(
                label: "Movie",
                icon: Icon(
                  Icons.movie,
                  color: selectectedIndex == 2 ? Colors.grey : Colors.red,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: selectectedIndex == 3 ? Colors.grey : Colors.red,
                ),
                label: "Favorite",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
