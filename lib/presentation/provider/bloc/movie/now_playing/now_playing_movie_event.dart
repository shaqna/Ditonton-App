part of 'now_playing_movie_bloc.dart';

abstract class NowPlayingMovieEvent extends Equatable {
  const NowPlayingMovieEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnFetchNowPlayingMovie extends NowPlayingMovieEvent{}
