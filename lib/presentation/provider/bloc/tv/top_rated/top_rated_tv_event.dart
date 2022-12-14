part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnFetchTopRatedTv extends TopRatedTvEvent {}