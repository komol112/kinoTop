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

  String selectedStatus = "Hammasi";

  /// Barcha statuslar ro‘yxati
  final List<String> allStatuses = [
    "Hammasi",
    "Korilgan",
    "Korilmagan",
    "Rejada",
  ];

  /// API orqali sahifa bo‘yicha ma’lumot olish
  Future<void> getMovie({required int page}) async {
    isLoading = true;
    notifyListeners();

    try {
      final fetchedData = await MovieService.fetchMovie(page: 1);

      if (fetchedData?.results != null) {
        // Har bir filmga default status biriktiramiz
        final List<Results> updatedResults =
            fetchedData!.results!.map((movie) {
              movie.status; // Agar status null bo‘lsa
              return movie;
            }).toList();

        pagedMovies[page] = updatedResults;
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

      // Qidiruvdagi filmlarga ham status qo‘shamiz
      if (searchResult?.results != null) {
        searchResult!.results =
            searchResult!.results!.map((movie) {
              movie.status;
              return movie;
            }).toList();
      }
    } catch (e) {
      errorMessage = "Qidiruvda xatolik: ${e.toString()}";
    }
    isLoading = false;
    notifyListeners();
  }

  /// Tanlangan statusni yangilash
  void setSelectedStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  /// Filmga yangi status berish
  void updateMovieStatus(int movieId, String newStatus) {
    for (var entry in pagedMovies.entries) {
      final index = entry.value.indexWhere((movie) => movie.id == movieId);
      if (index != -1) {
        entry.value[index].status = newStatus;
        break;
      }
    }
    notifyListeners();
  }

  /// Filterlangan filmlarni olish
  List<Results> getFilteredMovies() {
    final allMovies = pagedMovies.values.expand((list) => list).toList();

    if (selectedStatus == "Hammasi") {
      return allMovies;
    }

    return allMovies.where((movie) => movie.status == selectedStatus).toList();
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
