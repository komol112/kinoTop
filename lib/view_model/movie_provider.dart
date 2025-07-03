import 'package:flutter/material.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/repasitories/services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = "";

  /// Sahifalar bo‘yicha filmlar: Map<page, list of results>
  final Map<int, List<Results>> pagedMovies = {};

  /// Qidiruv natijalari uchun
  MovieModel? searchResult;

  /// API orqali sahifa bo‘yicha ma’lumot olish
  Future<void> getMovie({required int page}) async {
    isLoading = true;
    notifyListeners();

    try {
      final fetchedData = await MovieService.fetchMovie(page.toString(),);

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
  Future<void> searchMovie({
    required String movieName,
  }) async {
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
}
