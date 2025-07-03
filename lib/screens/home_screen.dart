import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/screens/detail_screen.dart';
import 'package:kino_top/screens/profile_screen.dart';
import 'package:kino_top/screens/search_delegate.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
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

        if (page1 == null || page2 == null) {
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
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.grey.shade200,
                ),
                onPressed: () {
                  showSearch(context: context, delegate: MovieSearchDelegate());
                },
                icon: Icon(
                  Icons.search,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade200
                          : Colors.grey.shade900,
                  size: 35.sp,
                ),
              ),
              SizedBox(width: 10.w),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.grey.shade200,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                icon: Icon(
                  Icons.person,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade200
                          : Colors.grey.shade900,
                  size: 35.sp,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: 300,
                  child: CarouselSlider.builder(
                    itemCount: page1.length,
                    itemBuilder: (context, index, realIdx) {
                      final movie = page1[index];
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 25,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45),
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade200,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Page 1",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.grey.shade200
                                                : Colors.grey.shade900,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      movie.originalTitle ?? "Trailer",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.grey.shade200
                                                : Colors.grey.shade900,
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "release date : ${movie.releaseDate ?? "Trailer"}",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.grey.shade200
                                                : Colors.grey.shade900,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Lang : ",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Text(
                                          movie.originalLanguage ?? "eng",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey.shade200
                                                : Colors.grey.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      height: 320,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                    ),
                  ),
                ),

                Row(
                  children: [
                    Text(
                      "Recommended Movies",
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade200
                                                : Colors.grey.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "see all",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5),

                SizedBox(
                  height: 300,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    mainAxisSpacing: 1,
                    childAspectRatio: 1.63,
                    crossAxisCount: 1,
                    children: List.generate(page1.length, (index) {
                      final movie = page1[index];
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(movie: movie),
                              ),
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Hero(
                                tag:
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              movie.title ?? "No Title",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(
                  height: 370,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    mainAxisSpacing: 1,
                    childAspectRatio: 2,
                    crossAxisCount: 1,

                    children: List.generate(page2.length, (index) {
                      final movie = page2[index];
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(movie: movie),
                              ),
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Hero(
                                tag:
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              movie.title ?? "No Title",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ?Colors.grey.shade200
                                        :Colors.grey.shade900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
