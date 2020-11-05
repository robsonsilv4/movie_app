import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movie_model.dart';
import 'movie_service.dart';

final moviesFutureProvider = FutureProvider.autoDispose<List<MovieModel>>(
  (ref) async {
    ref.maintainState = true;
    final movieService = ref.read(movieServiceProvider);
    final movies = await movieService.getMovies();
    return movies;
  },
);

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: watch(moviesFutureProvider).when(
        data: (movies) {
          return RefreshIndicator(
            onRefresh: () => context.refresh(moviesFutureProvider),
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
              children: movies.map((movie) => Text(movie.title)).toList(),
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Text('error'),
      ),
    );
  }
}
