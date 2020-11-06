import 'package:flutter/foundation.dart';

import 'movie_model.dart';

class MoviesPagination {
  final List<MovieModel> movies;
  final int page;
  final String errorMessage;

  MoviesPagination({
    this.movies,
    this.page,
    this.errorMessage,
  });

  MoviesPagination.initial()
      : movies = [],
        page = 1,
        errorMessage = '';

  bool get refreshError => errorMessage != '' && movies.length <= 20;

  MoviesPagination copyWith({
    List<MovieModel> movies,
    int page,
    String errorMessage,
  }) {
    return MoviesPagination(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'MoviesPagination(movies: $movies, page: $page, errorMessage: $errorMessage)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoviesPagination &&
        listEquals(o.movies, movies) &&
        o.page == page &&
        o.errorMessage == errorMessage;
  }

  @override
  int get hashCode => movies.hashCode ^ page.hashCode ^ errorMessage.hashCode;
}
