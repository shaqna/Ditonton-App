part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();

  @override
  List<Object> get props => [];
}

class TopRatedMovieEmpty extends TopRatedMovieState {

}

class TopRatedMovieLoading extends TopRatedMovieState {

}

class TopRatedMovieHasData extends TopRatedMovieState {
  final List<Movie> movies;

  TopRatedMovieHasData(this.movies);

  @override
  // TODO: implement props
  List<Object> get props => [movies];
}

class TopRatedMovieError extends TopRatedMovieState {
  final String message;

  TopRatedMovieError(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}