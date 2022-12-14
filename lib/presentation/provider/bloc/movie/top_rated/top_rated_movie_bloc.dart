import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies) : super(TopRatedMovieEmpty()) {
    on<OnFetchTopRatedMovie>((event, emit) async {
      emit(TopRatedMovieLoading());

      final results = await _getTopRatedMovies.execute();

      results.fold(
          (failure) {
            emit(TopRatedMovieError(failure.message));
          },
          (movies) {
            emit(TopRatedMovieHasData(movies));
          }
      );

    });
  }
}
