import 'dart:convert';

class MovieModel {
  final String title;
  final String posterPath;

  MovieModel({
    this.title,
    this.posterPath,
  });

  String get fullImageUrl => 'https://image.tmdb.org/t/p/w200$posterPath';

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'poster_path': posterPath,
    };
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MovieModel(
      title: map['title'],
      posterPath: map['posterPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieModel.fromJson(String source) =>
      MovieModel.fromMap(json.decode(source));
}