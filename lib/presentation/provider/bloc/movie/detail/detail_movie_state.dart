part of 'detail_movie_bloc.dart';

abstract class DetailMovieState extends Equatable {
  const DetailMovieState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DetailMovieEmpty extends DetailMovieState {}

class DetailMovieLoading extends DetailMovieState {}

class DetailMovieHasData extends DetailMovieState {
  final MovieDetail detailMovie;

  DetailMovieHasData(this.detailMovie);

  @override
  // TODO: implement props
  List<Object?> get props => [detailMovie];
}

class DetailMovieError extends DetailMovieState {
  final String message;

  DetailMovieError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
