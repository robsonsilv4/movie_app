import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/environment.dart';
import 'movie_model.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.read(environmentProvider);
  return MovieService(config, Dio());
});

class MovieService {
  final Environment _environment;
  final Dio _dio;

  MovieService(this._environment, this._dio);

  Future<List<MovieModel>> getMovies() async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/popular?api_key=${_environment.movieDbKey}&language=pt-BR&page=1',
    );

    final results = List<Map<String, dynamic>>.from(response.data['results']);

    List<MovieModel> movies =
        results.map((movie) => MovieModel.fromMap(movie)).toList();
    return movies;
  }
}
