import 'package:flutter/material.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/repasitories/services/movie_service.dart';
import 'package:kino_top/screens/detail_screen.dart';

class MovieSearchDelegate extends SearchDelegate {
  MovieSearchDelegate();

  @override
  String get searchFieldLabel => 'Search movies...';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white60),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type something to search...'));
    }

    return FutureBuilder<MovieModel>(
      future: MovieService.searchMovie(movieName: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final movie = snapshot.data;

        if (movie == null || movie.results == null || movie.results!.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: const EdgeInsets.all(12),
          children: List.generate(movie.results!.length, (index) {
            final result = movie.results![index];

            return GestureDetector(
              onTap: () {
                DetailScreen(movie: result);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag:
                          'https://image.tmdb.org/t/p/w500${result.posterPath}',
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${result.posterPath}',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),

                  Text(
                    result.title ?? "No title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Please enter a movie name'));
    }

    return FutureBuilder<MovieModel>(
      future: MovieService.searchMovie(movieName: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final results = snapshot.data?.results;
        if (results == null || results.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: const EdgeInsets.all(12),
          cacheExtent: 120,
          physics: const AlwaysScrollableScrollPhysics(),
          children: List.generate(results.length, (index) {
            final result = results[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(movie: result),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag:
                          'https://image.tmdb.org/t/p/w500${result.posterPath}',
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${result.posterPath}',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.title ?? result.title ?? "No title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
