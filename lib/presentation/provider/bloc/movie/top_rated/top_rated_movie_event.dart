part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieEvent extends Equatable {
  const TopRatedMovieEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnFetchTopRatedMovie extends TopRatedMovieEvent {}