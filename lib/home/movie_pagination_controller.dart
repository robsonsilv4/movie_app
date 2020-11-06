import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movie_service.dart';
import 'movies_exceptions.dart';
import 'movies_pagination.dart';

final moviePaginationControllerProvider =
    StateNotifierProvider<MoviePaginationController>(
  (ref) {
    final movieService = ref.read(movieServiceProvider);
    return MoviePaginationController(movieService);
  },
);

class MoviePaginationController extends StateNotifier<MoviesPagination> {
  final MovieService _movieService;

  MoviePaginationController(
    this._movieService, [
    MoviesPagination state,
  ]) : super(state ?? MoviesPagination.initial()) {
    getMovies();
  }

  Future<void> getMovies() async {
    try {
      final movies = await _movieService.getMovies(state.page);
      state = state.copyWith(movies: [
        ...state.movies,
        ...movies,
      ], page: state.page + 1);
    } on MoviesException catch (error) {
      state = state.copyWith(errorMessage: error.message);
    }
  }

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 20 == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ 20;

    if (requestMoreData && pageToRequest + 1 >= state.page) {
      getMovies();
    }
  }
}
