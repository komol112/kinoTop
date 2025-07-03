import 'dart:developer';

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
  int page = 1;

  @override
  void initState() {
    context.read<MovieProvider>().getMovie(page: page.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        final movie = movieProvider.movieModel;
        if (movie?.results == null) {
          return Center(child: CircularProgressIndicator());
        }

        log(movie?.results?[1].backdropPath?.toString() ?? "");
        log(movie?.results?[1].id.toString() ?? "0");

        log(movie?.results?.length.toString() ?? "lengz yoq");

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFF121011),

          appBar: AppBar(
            backgroundColor: Color(0xFF121011),
            leading: Text("Hey, Sarthak"),
            actions: [
              IconButton(
                style: IconButton.styleFrom(backgroundColor: Color(0xFF1E1E1E)),
                onPressed: () {
                  showSearch(context: context, delegate: MovieSearchDelegate());
                },
                icon: Icon(Icons.search, color: Colors.white, size: 35.sp),
              ),
              SizedBox(width: 10.w),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: Color(0xFF1E1E1E)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                icon: Icon(Icons.person, color: Colors.white, size: 35.sp),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: 320,
                  child: PageView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: List.generate(movie?.results?.length ?? 30, (
                      index,
                    ) {
                      return Column(
                        spacing: 8,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),

                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie?.results?[index].backdropPath}',
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: -50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 25,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(45),
                                      color: Colors.grey.shade900,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "next page ${page += 1}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          movie
                                                  ?.results?[index]
                                                  .originalTitle ??
                                              "Threiler",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        Text(
                                          "relase date : ${movie?.results?[index].releaseDate ?? "threiler"}",
                                          style: TextStyle(color: Colors.grey),
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          spacing: 5,
                                          children: [
                                            Text(
                                              "Lang : ",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              movie
                                                      ?.results?[index]
                                                      .originalLanguage ??
                                                  "eng",
                                              style: TextStyle(
                                                color: Colors.white,
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
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                Row(
                  children: [
                    Text(
                      "Recommended Movies",
                      style: TextStyle(
                        color: Colors.white,
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
                    childAspectRatio: 2,
                    mainAxisSpacing: 15,
                    cacheExtent: 120,
                    physics: AlwaysScrollableScrollPhysics(),

                    crossAxisCount: 1,
                    children: List.generate(movie?.results?.length ?? 30, (
                      index,
                    ) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DetailScreen(
                                    movie: movie!.results![index],
                                  ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Hero(
                                tag: ValueKey(
                                  'https://image.tmdb.org/t/p/w500${movie?.results?[index].posterPath}',
                                ),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie?.results?[index].posterPath}',
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              movie?.results?[index].title ?? "threiler",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(
                  height: 300,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    childAspectRatio: 2,
                    mainAxisSpacing: 15,
                    cacheExtent: 120,
                    physics: AlwaysScrollableScrollPhysics(),

                    crossAxisCount: 1,
                    children: List.generate(movie?.results?.length ?? 30, (
                      index,
                    ) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DetailScreen(
                                    movie: movie!.results![index],
                                  ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Hero(
                                tag: ValueKey(
                                  'https://image.tmdb.org/t/p/w500${movie?.results?[index].posterPath}',
                                ),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie?.results?[index].posterPath}',
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              movie?.results?[index].title ?? "threiler",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
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
