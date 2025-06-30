import 'package:flutter/material.dart';
import 'package:kino_top/models/movie_model.dart';
import 'package:kino_top/repasitories/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  bool isloading = false;

  MovieModel? movieModel;
  String errorMessage = "";
  Future<void> getMovie() async {
    isloading = true;
    try {
      final result = await MovieService.fetchMovie();
      movieModel = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovie({
    required String movieName,
    required String page,
  }) async {
    isloading = true;
    try {
      final getsearch = await MovieService.searchMovie(
        movieName: movieName,
        page: page,
      );
      movieModel = getsearch;
    } catch (e) {
      throw Exception(e);
    }
  }
}
