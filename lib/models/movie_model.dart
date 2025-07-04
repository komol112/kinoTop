class MovieModel {
  int? page;
  List<Results>? results;
  int? totalPages;
  int? totalResults;

  MovieModel({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      page: json['page'],
      results: json['results'] != null
          ? List<Results>.from(
              json['results'].map((v) => Results.fromJson(v)))
          : null,
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results?.map((v) => v.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}

class Results {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  /// ✅ Qo‘shilgan maydon: film statusi
  String status;

  Results({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.status = "Rejada", // default qiymat
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      genreIds: json['genre_ids']?.cast<int>(),
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      title: json['title'],
      video: json['video'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'],
      status: json['status'] ?? "Rejada", // API’dan kelmasa, default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'status': status, // saqlanmoqda
    };
  }
}
