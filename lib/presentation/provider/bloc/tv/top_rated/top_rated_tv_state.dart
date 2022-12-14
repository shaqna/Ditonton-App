part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object> get props => [];
}

class TopRatedTvEmpty extends TopRatedTvState {}

class TopRatedTvLoading extends TopRatedTvState {}

class TopRatedTvError extends TopRatedTvState {
  final String message;

  TopRatedTvError(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class TopRatedTvHasData extends TopRatedTvState {
  final List<Tv> list;

  TopRatedTvHasData(this.list);

  @override
  // TODO: implement props
  List<Object> get props => [list];
}
