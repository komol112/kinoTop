import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kino_top/screens/Login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  final pageController = PageController();

  int selctedpage = 0;

  late Timer _timer1;
  late Timer _timer2;

  final List<String> baseImages1 = [
    "assets/images/menitop.jpg",
    "assets/images/merlin.jpg",
    "assets/images/plice.jpg",
    "assets/images/milliy.jpg",
  ];

  final List<String> baseImages2 = [
    "assets/images/Rectangle 67.jpg",
    "assets/images/Rectangle 68.jpg",
    "assets/images/Rectangle 71.jpg",
    "assets/images/Rectangle 72.jpg",
  ];

  late List<String> images1;
  late List<String> images2;

  final double scrollSpeed = 1.0;

  @override
  void initState() {
    super.initState();

    images1 = List.generate(100, (i) => baseImages1[i % baseImages1.length]);
    images2 = List.generate(100, (i) => baseImages2[i % baseImages2.length]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double middleOffset1 = _scrollController1.position.maxScrollExtent / 2;
      double middleOffset2 = _scrollController2.position.maxScrollExtent / 2;

      _scrollController1.jumpTo(middleOffset1);
      _scrollController2.jumpTo(middleOffset2);

      _startAutoScroll(_scrollController1);
      _startAutoScroll(_scrollController2);
    });
  }

  void _startAutoScroll(ScrollController controller) {
    Timer timer = Timer.periodic(Duration(milliseconds: 18), (timer) {
      if (!controller.hasClients) return;

      double maxExtent = controller.position.maxScrollExtent;
      double minExtent = controller.position.minScrollExtent;
      double currentOffset = controller.offset;

      if (currentOffset >= maxExtent - 10) {
        controller.jumpTo((maxExtent - minExtent) / 2);
      }

      controller.jumpTo(currentOffset + scrollSpeed);
    });

    if (controller == _scrollController1) {
      _timer1 = timer;
    } else {
      _timer2 = timer;
    }
  }

  @override
  void dispose() {
    _timer1.cancel();
    _timer2.cancel();
    _scrollController1.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  int? selecteditem1;
  int? selecteditem2;
  int? selecteditem3;

  List<String> items1 = ["Comedy", "cinema", "sports", "Drama"];
  List<String> items2 = ["Fontastic", "Horror", "sports", "Documentary"];
  List<String> items3 = ["Uzbek kino", "action", "Sci-fi", "Theriliar"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFf121011),
      body: Column(
        spacing: 20,
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  selctedpage = value;
                });
              },
              controller: pageController,

              scrollDirection: Axis.horizontal,
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: pageOne(),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: pageTwo(),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              spacing: 18,

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color(0xFfEB2F3D),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    if (selctedpage != 1) {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    }
                  },
                  child: Text("Next"),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: List.generate(2, (index) {
                    return Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            selctedpage == index
                                ? Colors.red
                                : const Color.fromARGB(255, 32, 31, 31),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column pageOne() {
    return Column(
      spacing: 10,
      children: [
        SizedBox(height: 50),

        buildImageGridRow(images1, _scrollController1),
        buildImageGridRow(images2, _scrollController2),
        SizedBox(height: 50),
        Spacer(),

        SizedBox(
          width: 280,
          child: Text(
            textAlign: TextAlign.center,
            "Tell us about your favorite movie genres",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Column pageTwo() {
    return Column(
      spacing: 10,
      children: [
        Spacer(),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(60, 50),
                backgroundColor:
                    selecteditem1 == index
                        ? Color(0xFFEB2F3D)
                        : Color.fromARGB(255, 39, 38, 38),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  selecteditem1 = index;
                });
              },
              child: Text(items1[index]),
            );
          }),
        ),

        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(60, 50),
                backgroundColor:
                    selecteditem2 == index
                        ? Color(0xFFEB2F3D)
                        : Color.fromARGB(255, 39, 38, 38),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  selecteditem2 = index;
                });
              },
              child: Text(items2[index]),
            );
          }),
        ),

        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(60, 50),
                backgroundColor:
                    selecteditem3 == index
                        ? Color(0xFFEB2F3D)
                        : Color.fromARGB(255, 39, 38, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  selecteditem3 = index;
                });
              },
              child: Text(items3[index]),
            );
          }),
        ),
        Spacer(),

        SizedBox(
          width: 280,
          child: Text(
            textAlign: TextAlign.center,
            "Select thr genres you like to watch",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),

        SizedBox(height: 30),
      ],
    );
  }

  Widget buildImageGridRow(List<String> images, ScrollController controller) {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 150,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              images[index],
              fit: BoxFit.cover,
              width: 120,
              height: 180,
            ),
          );
        },
      ),
    );
  }
}
