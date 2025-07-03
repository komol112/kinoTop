// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:kino_top/screens/fav_screen.dart';
// import 'package:kino_top/screens/home_secreen.dart';
// import 'package:kino_top/screens/details_screen.dart';
// import 'package:kino_top/screens/history_screen.dart';

// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({super.key});

//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   int selectectedIndex = 0;

//   List<Widget> screens = [
//     HomeScreen(),
//     HitoryScreen(),
//     DetailsScreen(),
//     FavScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[selectectedIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.amber,
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(30),
//             topLeft: Radius.circular(30),
//           ),
//           boxShadow: [
//             BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30.0),
//             topRight: Radius.circular(30.0),
//           ),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.shifting,
//             onTap: (value) {
//               log(value.toString());
//               setState(() {
//                 selectectedIndex = value;
//               });
//             },
//             selectedItemColor: Colors.grey,
//             unselectedItemColor: Colors.red,
//             showUnselectedLabels: true,
//             showSelectedLabels: true,
//             currentIndex: selectectedIndex,
//             items: [
//               BottomNavigationBarItem(
//                 label: "Home",
//                 icon: Icon(
//                   Icons.home,
//                   color: selectectedIndex == 0 ? Colors.grey : Colors.red,
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.phone,
//                   color: selectectedIndex == 1 ? Colors.grey : Colors.red,
//                 ),

//                 label: "phone",
//               ),
//               BottomNavigationBarItem(
//                 label: "Movie",
//                 icon: Icon(
//                   Icons.movie,
//                   color: selectectedIndex == 2 ? Colors.grey : Colors.red,
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.favorite,
//                   color: selectectedIndex == 3 ? Colors.grey : Colors.red,
//                 ),
//                 label: "Favorite",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:kino_top/screens/home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;

  List<Widget> get screens => [
    HomeScreen(),
    Center(
      child: Text(
        "📺 Shorts",
        style: TextStyle(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade900,
          fontSize: 32,
        ),
      ),
    ),
    Center(
      child: Text(
        "🎫 My Card",
        style: TextStyle(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade900,
          fontSize: 32,
        ),
      ),
    ),
    Center(
      child: Text(
        "⚙️ Settings",
        style: TextStyle(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade900,
          fontSize: 32,
        ),
      ),
    ),
  ];

  final List<String> labels = ["Movies", "Shorts", "My Card", "Settings"];
  final List<IconData> icons = [
    Icons.movie_creation_rounded,
    Icons.smart_display_outlined,
    Icons.local_activity_outlined,
    Icons.more_horiz,
  ];

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    debugPrint('Clicked: ${labels[index]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.white,

      body: IndexedStack(index: selectedIndex, children: screens),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 50, right: 25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
         
            borderRadius: BorderRadius.circular(100), // ✅ 100% radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(icons.length, (index) {
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () => _onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding:
                      isSelected
                          ? const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          )
                          : const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.red
                            : Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade200
                            : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child:
                      isSelected
                          ? Row(
                            children: [
                              Icon(
                                icons[index],
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade200,
                                size: 30,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                labels[index],
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade200,
                                ),
                              ),
                            ],
                          )
                          : Icon(
                            icons[index],
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade200,
                            size: 24,
                          ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
