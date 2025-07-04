import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:kino_top/view/utils/widgets.dart';
import 'package:kino_top/view_model/movie_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final movieProvider = context.read<MovieProvider>();
      movieProvider.getMovie(page: 1);
      movieProvider.getMovie(page: 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        final page1 = movieProvider.pagedMovies[1] ?? [];
        final page2 = movieProvider.pagedMovies[2] ?? [];

        if (page1.isEmpty || page2.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF121011)
                  : Colors.white,

          appBar: AppBar(
            backgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF121011)
                    : Colors.white,
            leading: Text("Hey, Sarthak"),
            actions: [
              searchDelegateWidget(context),
              SizedBox(width: 10.w),
              profileButtonWidget(context),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                pageViewAvtoScrollWidget(page1),

                SeeAllButtonWidget(context, text: "Recommended Movies"),

                SizedBox(height: 5),

                pageOneScrollWidget(page1, context),

                SeeAllButtonWidget(context, text: "Top Movies "),

                SizedBox(height: 5),

                pageTwoScrollWidget(page2, context),
              ],
            ),
          ),
        );
      },
    );
  }
}
