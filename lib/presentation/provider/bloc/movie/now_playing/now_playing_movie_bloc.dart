import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_movie_event.dart';
part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMovieBloc(this._getNowPlayingMovies) : super(NowPlayingMovieEmpty()) {
    on<OnFetchNowPlayingMovie>((event, emit) async {
      emit(NowPlayingMovieLoading());
      final results = await _getNowPlayingMovies.execute();

      results.fold(
          (failure) {
            emit(NowPlayingMovieError(failure.message));
          },
          (movies) {
            emit(NowPlayingMovieHasData(movies));
          }
      );
    });
  }
}
