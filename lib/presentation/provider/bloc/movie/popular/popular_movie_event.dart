part of 'popular_movie_bloc.dart';

abstract class PopularMovieEvent extends Equatable {
  const PopularMovieEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnFetchPopularMovie extends PopularMovieEvent {

}
