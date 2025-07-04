import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/view/screens/all_movies_screen.dart';
import 'package:kino_top/view/screens/detail_screen.dart';
import 'package:kino_top/view/screens/profile_screen.dart';
import 'package:kino_top/view/screens/search_delegate.dart';
import 'package:kino_top/view_model/movie_provider.dart';
import 'package:provider/provider.dart';

SizedBox pageTwoScrollWidget(List<Results> page2, BuildContext context) {
  return SizedBox(
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
                MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                movie.title ?? "No Title",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.dark
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
  );
}

SizedBox pageOneScrollWidget(List<Results> page1, BuildContext context) {
  return SizedBox(
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
                MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                movie.title ?? "No Title",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.dark
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
  );
}

Row SeeAllButtonWidget(BuildContext context, {required String text}) {
  return Row(
    children: [
      Text(
        text,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllMoviesScreen()),
          );
        },
        child: Text("see all", style: TextStyle(color: Colors.red)),
      ),
    ],
  );
}

SizedBox pageViewAvtoScrollWidget(List<Results> page1) {
  return SizedBox(
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
              child: CachedNetworkImage(
                placeholder: (context, url) => CupertinoActivityIndicator(),
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                width: double.infinity,
                height: 230,
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
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color:
                        Theme.of(context).brightness == Brightness.dark
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
                              Theme.of(context).brightness == Brightness.dark
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
                              Theme.of(context).brightness == Brightness.dark
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
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade200
                                  : Colors.grey.shade900,
                        ),
                      ),
                      Row(
                        children: [
                          Text("Lang : ", style: TextStyle(color: Colors.red)),
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
        height: 330,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.98,
      ),
    ),
  );
}

IconButton profileButtonWidget(BuildContext context) {
  return IconButton(
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
  );
}

IconButton searchDelegateWidget(BuildContext context) {
  return IconButton(
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
  );
}

class getAllMoviesScrolWidget extends StatelessWidget {
  const getAllMoviesScrolWidget({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, controller, child) {
        if (controller.isLoading && controller.movies.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(15),
          itemCount: controller.movies.length + (controller.isLoading ? 2 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            // Yangi sahifa yuklanayotganda loading indikator ko'rsatish
            if (index >= controller.movies.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final movie = controller.movies[index];

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
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            height: 250,
                            color: Colors.grey,
                            child: const Icon(Icons.broken_image),
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title ?? "Trailer",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade200
                              : Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
