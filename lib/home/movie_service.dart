import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/environment.dart';
import 'movie_model.dart';
import 'movies_exceptions.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.read(environmentProvider);
  return MovieService(config, Dio());
});

class MovieService {
  final Environment _environment;
  final Dio _dio;

  MovieService(this._environment, this._dio);

  Future<List<MovieModel>> getMovies([int page = 1]) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/popular?api_key=${_environment.movieDbKey}&language=pt-BR&page=$page',
      );

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<MovieModel> movies = results
          .map((movie) => MovieModel.fromMap(movie))
          .toList(growable: false);
      return movies;
    } on DioError catch (error) {
      throw MoviesException.fromDioError(error);
    }
  }
}
