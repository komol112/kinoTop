import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kino_top/models/movie_model.dart';

// Bu tokenni saqlab qo'yilgan holatda
const token =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NWM4NzdhN2U4ZTA1ZTM2M2M4ZGFhMDY5NDU0MGQ2MiIsIm5iZiI6MTc1MDkyOTQxMC4wNDMsInN1YiI6IjY4NWQxMDAyMWE4ZTE3MmFjOTdlYzlkNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.T1pFgTfZKmbItrkkqevlTxByM8PDxHsPHm80zlW6t9g';

class MovieService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ),
  );

  /// Sahifalab film olish
  static Future<MovieModel?> fetchMovie({required int page}) async {
    log("Servicega kirdi: page = $page");

    try {
      final response = await _dio.get(
        '/trending/all/day',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        log("✅ Ma'lumot keldi");
        return MovieModel.fromJson(response.data);
      } else {
        log("❌ Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("❗️Xatolik fetchMovie: $e");
      return null;
    }
  }

  /// Film nomi bo‘yicha qidiruv
static Future<MovieModel?> searchMovie({
  required String movieName,
  int page = 1,
  bool includeAdult = false,
  String language = 'en-US',
}) async {
  try {
    final response = await _dio.get(
      '/search/movie',
      queryParameters: {
        'query': movieName,
        'page': page,
        'include_adult': includeAdult,
        'language': language,
      },
    );

    if (response.statusCode == 200) {
      log("🔍 Search muvaffaqiyatli: $movieName");
      return MovieModel.fromJson(response.data);
    } else {
      log("❌ Search status: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    log("❗️Xatolik searchMovie: $e");
    return null;
  }
}




}
