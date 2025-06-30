import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kino_top/models/movie_model.dart';

const token =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NWM4NzdhN2U4ZTA1ZTM2M2M4ZGFhMDY5NDU0MGQ2MiIsIm5iZiI6MTc1MDkyOTQxMC4wNDMsInN1YiI6IjY4NWQxMDAyMWE4ZTE3MmFjOTdlYzlkNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.T1pFgTfZKmbItrkkqevlTxByM8PDxHsPHm80zlW6t9g';

class MovieService {
  static Future<MovieModel?> fetchMovie() async {
    log("Servicega kirdi");

    final dio = Dio();

    log("dioga kirildi");

    try {
      log("tryga kirildi");
      final response = await dio.get(
        "https://api.themoviedb.org/3/trending/all/day?-US&page=1",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        log(response.statusCode.toString());

        return MovieModel.fromJson(response.data);
      } else {
        log(response.statusCode.toString());
        throw Exception("Xatolik mavjud !!!");
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  //search sorov yuborish uchun

  static Future<MovieModel> searchMovie({
    required String movieName,
    required String page,
  }) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        "https://api.themoviedb.org/3/search/movie?query=$movieName&include_adult=false&language=en-US&page=$page",
      );

      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      } else {
        throw Exception("error bor search serviceda");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
