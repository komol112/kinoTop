import 'package:flutter/material.dart';
import 'package:kino_top/screens/fav_screen.dart';
import 'package:kino_top/screens/home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    FavScreen(),
    Center(
      child: Text(
        "🎫 My Card",
        style: TextStyle(color: Colors.white, fontSize: 32),
      ),
    ),
    Center(
      child: Text(
        "⚙️ Settings",
        style: TextStyle(color: Colors.white, fontSize: 32),
      ),
    ),
  ];

  final List<String> labels = ["Movies", "Liked Movies", "My Card", "Settings"];
  final List<IconData> icons = [
    Icons.movie_creation_rounded,
    Icons.favorite_border_outlined,
    // Icons.favorite,
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
      backgroundColor: Color(0xFF121011),

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
                    color: isSelected ? Colors.red : Colors.grey[850],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child:
                      isSelected
                          ? Row(
                            children: [
                              Icon(icons[index], color: Colors.white, size: 30),
                              const SizedBox(width: 8),
                              Text(
                                labels[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                          : Icon(icons[index], color: Colors.white, size: 24),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
