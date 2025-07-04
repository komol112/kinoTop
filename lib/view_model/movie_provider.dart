import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/repasitories/services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = "";

  final Map<int, List<Results>> pagedMovies = {};

  List<MovieModel> allMovies = [];

  MovieModel? searchResult;

  Future<void> getMovie({required int page}) async {
    isLoading = true;
    notifyListeners();

    try {
      final fetchedData = await MovieService.fetchMovie(page: 1);

      if (fetchedData?.results != null) {
        pagedMovies[page] = fetchedData!.results!;
      } else {
        errorMessage = "Ma'lumot yo'q";
      }
    } catch (e) {
      errorMessage = "Xatolik: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }

  /// Qidiruv
  Future<void> searchMovie({required String movieName}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await MovieService.searchMovie(movieName: movieName);
      searchResult = result;
    } catch (e) {
      errorMessage = "Qidiruvda xatolik: ${e.toString()}";
    }
    isLoading = false;
    notifyListeners();
  }

  /// Barcha sahifalarni tozalash
  void clearMovies() {
    pagedMovies.clear();
    notifyListeners();
  }

  //all movies

  int _currentPage = 3;
  bool hasMore = true;

  List<Results> _movies = [];
  List<Results> get movies => _movies;

  Future<void> getAllMovies() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();

    try {
      final movieModel = await MovieService.fetchMovie(page: _currentPage);

      final newMovies = movieModel?.results ?? [];

      log("📦 Kelgan yangi film soni: ${newMovies.length}");

      if (_currentPage >= 500) {
        hasMore = false;
      } else {
        _movies.addAll(newMovies as Iterable<Results>);
        _currentPage++;
      }
    } catch (e) {
      log("❌ Xatolik: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
