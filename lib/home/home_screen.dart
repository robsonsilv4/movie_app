import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movie_model.dart';
import 'movie_service.dart';
import 'movies_exceptions.dart';

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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Movie App'),
      ),
      body: watch(moviesFutureProvider).when(
        data: (movies) {
          return RefreshIndicator(
            onRefresh: () => context.refresh(moviesFutureProvider),
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
              children: movies.map((movie) => _MovieBox(movie: movie)).toList(),
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) {
          if (error is MoviesException) {
            return _ErrorBody(message: error.message);
          }
          return _ErrorBody(message: 'Ooops, something unexpected happended.');
        },
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final MovieModel movie;

  const _MovieBox({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FrontBanner(text: movie.title),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  final String text;

  const _FrontBanner({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 60.0,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          RaisedButton(
            onPressed: () => context.refresh(moviesFutureProvider),
            child: Text("Try again!"),
          ),
        ],
      ),
    );
  }
}
